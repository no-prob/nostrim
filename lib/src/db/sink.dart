import 'package:nostr/nostr.dart';

import 'db.dart' as db;
import 'crud.dart';
import '../relays.dart';
import '../../config/settings.dart';


Relays? relays;

Relays getRelays() {
  if (relays != null) {
    return relays!;
  }
  relays = Relays();
  relaySettings.forEach((name, url) {
    relays?.add(name, url);
  });
  return relays!;
}


class EventSink {
  //late User user;
  //late Relays relays;

  //EventSink(this.user, this.relays);
  EventSink();

  listen() {
    Relays relays = getRelays();
    relays?.listen(
      (data) {
        if (data == null || data == 'null') {
          return;
        }
        Message m = Message.deserialize(data);
        if ([m.type,].contains("EVENT")) {
          Event event = m.message;
          createEvent(event);
          //Event queriedEvent = await readEvent(event.id);
          //print("");
          print("######## RECEIVED EVENT #########");
          //print(data);
        }
      },
    );
  }
}
