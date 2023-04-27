import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:nostr/nostr.dart';

import '../config/settings.dart';
import 'db/crud.dart';


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

  void listen(void Function(dynamic) func) {
    socket.stream.listen(
      func,
      onError: (err) => print("Error in creating connection to $url."),
      onDone: () => print('Relay[$name]: In onDone'),
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
    // TODO: check the return OK if relay supports that NIP
  }

  Future<void> sendEvent(Event event) async {
    await send(event.serialize());
    createEvent(event);
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

  sendMessage(String content) {
    EncryptedDirectMessage event = EncryptedDirectMessage.redact(
      getKey('alice', 'priv'),
      getKey('bob', 'pub'),
      content,
    );
    sendEvent(event);
  }

  sendEvent(Event event) {
    relays?.forEach((relay) {
      relay.sendEvent(event);
    });
  }

  void listen(dynamic func) {
    relays?.forEach((relay) {
      relay.listen(func);
    });
  }
}

