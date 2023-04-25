import 'package:drift/drift.dart';
import 'package:nostr/nostr.dart' as nostr;

import 'db.dart';
import '../../config/settings.dart';

Future<void> createEvent(nostr.Event event) async {
  String plaintext = "";
  bool decryptError = false;
  try {
    plaintext = (event as nostr.EncryptedDirectMessage).getPlaintext(getKey('bob', 'priv'));
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

Future<nostr.Event> readEvent(String id) async {
  Event entry = await (database.select(database.events)
        ..where((t) => t.id.equals(id)))
      .getSingle();
  nostr.Event event = nostr.Event.partial();
  event.id = entry.id;
  event.pubkey = entry.pubkey;
  event.content = entry.content;
  event.createdAt = entry.createdAt as int;
  event.kind = entry.kind;
  event.sig = entry.sig;
  return event;
}
