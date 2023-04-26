import 'package:drift/drift.dart';
import 'package:nostr/nostr.dart' as nostr;

import 'db.dart';
import '../../config/settings.dart';
import '../../models/message_entry.dart';

Future<void> createEvent(nostr.Event event) async {
  try {
    await database.into(database.events).insert(
          EventsCompanion.insert(
            id: event.id,
            pubkey: event.pubkey,
            content: event.content,
            createdAt: DateTime.fromMillisecondsSinceEpoch(event.createdAt * 1000),
            kind: event.kind,
            sig: event.sig,
            plaintext: "",
            decryptError: false,
          ),
          onConflict: DoNothing(),
        );
  } catch(err) {
    if (!err.toString().contains("UNIQUE constraint failed")) {
      // ignore dups
      print(err);
    } else {
      // return from here because the entry already exists.
      return;
    }
  }
  String plaintext = "";
  bool decryptError = false;
  try {
    // TODO: Consider not storing the plaintext
    plaintext = (event as nostr.EncryptedDirectMessage).getPlaintext(getKey('bob', 'priv'));
  } catch(err) {
    decryptError = true;
    print(err);
  }
  updateEventPlaintext(event, plaintext, decryptError);
}

Future<void> updateEventPlaintext(nostr.Event event, String plaintext, bool decryptError) async {
  final insert = EventsCompanion.insert(
      id: event.id,
      pubkey: event.pubkey,
      content: event.content,
      createdAt: DateTime.fromMillisecondsSinceEpoch(event.createdAt * 1000),
      kind: event.kind,
      sig: event.sig,
      plaintext: plaintext,
      decryptError: decryptError,
  );
  final update = EventsCompanion.custom(
      plaintext: Variable(plaintext),
      decryptError: Variable(decryptError),
  );
  try {
    await database
        .into(database.events)
        .insert(insert, onConflict: DoUpdate((_) => update));
  } catch(err) {
    print(err);
  }
}

class NostrEvent extends nostr.EncryptedDirectMessage {
  late String plaintext;
  NostrEvent(nostr.Event event, this.plaintext): super(event, verify: false);
}

List<NostrEvent> nostrEvents(List<Event> entries) {
  List<NostrEvent> events = [];
  for (final entry in entries) {
    nostr.Event event = nostr.Event.partial();
    event.id = entry.id;
    event.pubkey = entry.pubkey;
    event.content = entry.content;
    event.createdAt = entry.createdAt.millisecondsSinceEpoch;
    event.kind = entry.kind;
    event.sig = entry.sig;
    assert(event.kind == 4);
    // TODO: Need TAGS for id to pass isValid()
    events.add(NostrEvent(event, entry.plaintext!));
  }
  print('returning events $events');
  return events;
}

Future<List<NostrEvent>> readEvent(String id) async {
  List<Event> entries = await (database.select(database.events)
        ..where((t) => t.id.equals(id)))
      .get();
  return nostrEvents(entries);
}

Stream<List<NostrEvent>> watchEvents([int from=0]) async* {
  Stream<List<Event>> entries = await (database.select(database.events)).watch();
  await for (final entryList in entries) {
    yield nostrEvents(entryList);
  }
}

Stream<List<MessageEntry>> watchMessages([DateTime? from]) async* {
  Stream<List<Event>> entries = await (database.select(database.events)).watch();
  List<MessageEntry> messages = [];
  await for (final entryList in entries) {
    List<NostrEvent> events = nostrEvents(entryList);
    for (final event in events) {
      messages.add(MessageEntry(
          messageContent: event.plaintext,
          messageType: "receiver",
        )
      );
    }
  }
  yield messages;
}
