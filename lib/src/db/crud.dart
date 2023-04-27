import 'package:drift/drift.dart';
import 'package:nostr/nostr.dart' as nostr;

import 'db.dart';
import '../../config/settings.dart';
import '../../models/message_entry.dart';
import '../contact.dart' as contact;
import '../logging.dart';

Future<void> createEvent(nostr.Event event, [String? plaintext]) async {
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
  if (plaintext == null) {
    bool decryptError = false;
    try {
      // TODO: Consider not storing the plaintext
      plaintext = (event as nostr.EncryptedDirectMessage).getPlaintext(getKey('bob', 'priv'));
    } catch(err) {
      decryptError = true;
      print(err);
    }
    updateEventPlaintext(event, decryptError ? "" : plaintext!, decryptError);
  }
  plaintext ??= "<decrypt error>";
  logEvent(event, plaintext);
}

Future<void> updateEventPlaintext(
    nostr.Event event,
    String plaintext,
    bool decryptError,
  ) async {
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
  try {
    await database
        .into(database.events)
        .insert(insert, mode: InsertMode.insertOrReplace);
  } catch(err) {
    print(err);
  }
}

class NostrEvent extends nostr.EncryptedDirectMessage {
  final String plaintext;
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
  return events;
}

Future<List<NostrEvent>> readEvent(String id) async {
  List<Event> entries = await (database.select(database.events)
        ..where((t) => t.id.equals(id)))
      .get();
  return nostrEvents(entries);
}

Stream<List<MessageEntry>> watchMessages([DateTime? from]) async* {
  Stream<List<Event>> entries = await (
    database
      .select(database.events)
      ..orderBy([(t) => OrderingTerm(
           expression: t.createdAt,
           mode: OrderingMode.desc,
        )]
      )
    ).watch();
  await for (final entryList in entries) {
    List<NostrEvent> events = nostrEvents(entryList);
    List<MessageEntry> messages = [];
    for (final event in events) {
      messages.add(MessageEntry(
          content: event.plaintext,
          type: "receiver",
          timestamp: DateTime.fromMillisecondsSinceEpoch(event.createdAt * 1000),
          contact: contact.Contact(event.pubkey),
        )
      );
    }
    yield messages;
  }
}
