import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:nostr/nostr.dart';

import '../config/settings.dart';


// XXX JUNK DEBUG
String getKey(String user, String key) {
    Map<String, dynamic> keys = {
        'bob': {
            'pub': '2d38a56c4303bc722370c50c86fc8dd3327f06a8fe59b3ff3d670738d71dd1e1',
            'priv': '826ef0e93c1278bd89945377fadb6b6b51d9eedf74ecdb64a96f1897bb670be8',
         },
        'alice': {
            'pub': '0f76c800a7ea76b83a3ae87de94c6046b98311bda8885cedd8420885b50de181',
            'priv': '773dc29ff81f7680eeca5d530f528e8c572979b46abc8bfd1586b73a6a98ab4d',
        },
    };
    return keys[user][key];
}


class Relay {
  String name;
  String url;
  Map<String, WebSocketChannel> socketMap = {};
  List<int>? supportedNips;
  List<Filter> filters = [Filter(
    //kinds: [0, 1, 4, 2, 7],
    kinds: [4],
    since: 1681878751, // TODO: Today minus 30 or something, or based on last received in db
    limit: 450,
  )];

  Relay(this.name, this.url, [filters]) {
    this.filters = this.filters + (filters ?? []);
    socketMap[name] = socketConnect(url);
    //listen();
    subscribe();
  }

  WebSocketChannel get socket => socketMap[name]!;

  static WebSocketChannel socketConnect(String host) {
    host = host.split('//').last;
    WebSocketChannel socket;
    try {
      // with 'wss' seeing WRONG_VERSION_NUMBER error against some servers
      socket = WebSocketChannel.connect(Uri.parse('ws://${host}'));
    } on HandshakeException catch(e) {
      socket = WebSocketChannel.connect(Uri.parse('wss://${host}'));
    }
    return socket;
  }

  void subscribe() {
    // TODO: query supported nips
    Request requestWithFilter = Request(generate64RandomHexChars(), filters);
    print('sending request: ${requestWithFilter.serialize()}');
    socket.sink.add(requestWithFilter.serialize());
  }

  // XXX JUNK DEBUG
  void debugCode(String data) {
    Message m = Message.deserialize(data);
    if ([m.type,].contains("EVENT")) {
      Event event = m.message;
      String content = event.content;
      if (event.kind == 4) {
        String senderPubkey = "";
        event.tags.forEach((tag) {
          if (tag[0] == 'p') {
            if (tag[1] != getKey('bob', 'pub')) {
              print('@@@@@@@@@@@@@@@@ Not sure who this DM is to: ${tag[1]}');
            }
            senderPubkey = tag[1];
          }
        });
        content = (event as EncryptedDirectMessage).getPlaintext(getKey('bob', 'priv'));
      }
      print("");
      print("######## EVENT #########");
      print(data);
      print("kind[${event.kind}], isValid[${event.isValid()}]");
      print("content=${content}");
      //print(event.serialize());
    }
  }
    
  void listen([void Function(dynamic)? func]) {
    func ??= (data) {
      if (data == null || data == 'null') {
        return;
      }
      // TODO: deserialize, insert in db, then add to UI components stream
      debugCode(data);
    };

    socket.stream.listen(
      func,
      onError: (err) {
        print("Error in creating connection to $url.");
      },
      onDone: () { print('Relay[$name]: In onDone'); }
    );
  }

  void close() {
    try {
      socket.sink.close();
    } catch(err) {
      // TODO: Logging
      print('Close exception error $err for relay $name');
    }
  }

  Future<void> send(String request) async {
    socket.sink.add(request);
  }

  void sendEvent(Event event) {
    send(event.serialize());
  }
}


class Relays {
  String groupName; // private relay, group/org relay, public relay, etc.
  List<Relay>? relays;
  Set<Event>? rEvents;
  Set<String>? uniqueIdsReceived; // to reject duplicates, but may check database instead

  Relays({
    this.groupName='default',
  }) {
    relays = [];
    rEvents = {};
    uniqueIdsReceived = {};
  }

  void close() {
    relays?.forEach((relay) {
      relay.close();
    });
  }

  void add(name, url) {
    Relay relay = Relay(name, url);
    if (relay.socketMap[name] != null) {
      relays?.add(relay);
    }
  }

  send(String request) {
    relays?.forEach((relay) {
      relay.send(request);
    });
  }

  void listen(dynamic func) {
    relays?.forEach((relay) {
      relay.listen(func);
    });
  }
}

