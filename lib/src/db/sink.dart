import 'package:nostr/nostr.dart';
import 'package:intl/intl.dart'; // for date format
import 'package:intl/date_symbol_data_local.dart'; // for other locales
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart';

import 'db.dart' as db;
import 'crud.dart';
import '../relays.dart';
import '../../config/settings.dart';

//initializeDateFormatting('fr_FR', null).then((_) => runMyCode());

DateTime timezoned(DateTime date) {
  initializeTimeZones();
  //var locations = timeZoneDatabase.locations;
  //locations.keys.forEach((key) => print(key));
  final timeZone = getLocation(timezone);
  return TZDateTime.from(date, timeZone);
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
          logEvent(event);
        }
      },
    );
  }
  void logEvent(event) {
    String to = whoseKey(event.receiver) ?? "unknown";
    String from = whoseKey(event.pubkey) ?? "unknown";
    DateTime timestamp = timezoned(DateTime.fromMillisecondsSinceEpoch(event.createdAt * 1000));
    String date = DateFormat('yyyy-MM-dd').format(timestamp);
    String time = DateFormat('hh:mm:ss').format(timestamp);
    print('Message to $to from $from on $date at $time');
  }
}
