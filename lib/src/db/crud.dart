import 'package:drift/drift.dart';
import 'package:nostr/nostr.dart' as nostr;

import 'db.dart';
import '../../config/settings.dart';

Future<void> createEvent(nostr.Event event) async {
  String plaintext = "";
  bool decryptError = false;
  try {
    // TODO: Consider not storing the plaintext
    //plaintext = (event as nostr.EncryptedDirectMessage).getPlaintext(getKey('bob', 'priv'));
  } catch(err) {
    decryptError = true;
    print(err);
  }
  try {
    await database.into(database.events).insert(
          EventsCompanion.insert(
            id: event.id,
            pubkey: event.pubkey,
            content: event.content,
            plaintext: plaintext,
            createdAt: DateTime.fromMillisecondsSinceEpoch(event.createdAt * 1000),
            kind: event.kind,
            sig: event.sig,
            decryptError: decryptError,
          ),
          onConflict: DoNothing(),
        );
  } catch(err) {
    if (!err.toString().contains("UNIQUE constraint failed")) {
      // ignore dups
      print(err);
    }
  }
}

List<nostr.Event> nostrEvents(List<Event> entries) {
  List<nostr.Event> events = [];
  for (final entry in entries) {
    nostr.Event event = nostr.Event.partial();
    event.id = entry.id;
    event.pubkey = entry.pubkey;
    event.content = entry.content;
    event.createdAt = entry.createdAt.millisecondsSinceEpoch;
    event.kind = entry.kind;
    event.sig = entry.sig;
    if (event.kind == 4) {
      // TODO: Need TAGS for id to pass isValid()
      events.add(nostr.EncryptedDirectMessage(event, verify: false));
    } else {
      events.add(event);
    }
  }
  print('returning events $events');
  return events;
}

Future<List<nostr.Event>> readEvent(String id) async {
  List<Event> entries = await (database.select(database.events)
        ..where((t) => t.id.equals(id)))
      .get();
  return nostrEvents(entries);
}

Stream<List<nostr.Event>> watchEvents([int from=0]) async* {
  Stream<List<Event>> entries = await (database.select(database.events)).watch();
  await for (final entryList in entries) {
    yield nostrEvents(entryList);
  }
}
