import 'package:nostr/nostr.dart';

import 'db.dart' as db;
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

  void listen() {
    Relays relays = getRelays();
    relays?.listen(
      (data) {
        if (data == null || data == 'null') {
          return;
        }
        Message m = Message.deserialize(data);
        //print(data);
        if ([m.type,].contains("EVENT")) {
          Event event = m.message;
          String content = event.content;
          if (event.kind == 4) {
            String receiverPubkey = "";
            event.tags.forEach((tag) {
              if (tag[0] == 'p') {
                if (tag[1] != getKey('bob', 'pub')) {
                  print('@@@@@@@@@@@@@@@@ Not sure who this DM is to: ${tag[1]}');
                }
                receiverPubkey = tag[1];
              }
            });
            content = (event as EncryptedDirectMessage).getPlaintext(getKey('bob', 'priv'));
          }
          print("");
          print("######## EVENT #########");
          print(data);
          print("kind[${event.kind}], isValid[${event.isValid()}]");
          print("content=${content}");
        }
      },
    );
  }
}
