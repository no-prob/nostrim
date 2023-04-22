import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nostr/nostr.dart';

import '../models/events.dart';
import '../components/chats/chats_entry.dart';
import '../components/drawer/index.dart';
import '../src/relays.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({Key? key, this.title='Messages'}) : super(key: key);
  final String title;

  @override
  _ChatsListState createState() => _ChatsListState();
}

List<Widget> myChatsEntries = [];

List<Widget> getSome() {
  List<Widget> newEntries = [
    ChatsEntry(
      name: "John Jacob",
      picture: NetworkImage(
        "https://i.ytimg.com/vi/D7h9UMADesM/maxresdefault.jpg",
      ),
      type: "group",
      sending: "Your",
      lastTime: "02:45",
      seeing: 2,
      lastMessage: "https://github.com/",
    ),
    Divider(height: 0),
    ChatsEntry(
      name: "Jinkle Hiemer",
      picture: NetworkImage(
        "https://i.ytimg.com/vi/D7h9UMADesM/maxresdefault.jpg",
      ),
      lastTime: "02:16",
      type: "group",
      sending: "Mesud",
      lastMessage: "gece gece sinirim bozuldu.",
    ),
    Divider(height: 0),
  ];

  myChatsEntries.addAll(newEntries);
  return myChatsEntries;
}

class _ChatsListState extends State<ChatsList> {
  List<String> npubs = [];
  bool showOtherUsers = false;
  int selectedUser = 0;
  late Relays relays;

  @override
  void initState() {
    super.initState();
    relays = getRelays();
  }

  final bool _running = true;

  Stream<String> _event() async* {
    while (_running) {
      relays.listen(
        (data) {
          if (data == null || data == 'null') {
            return;
          }
          Message m = Message.deserialize(data);
          print(data);
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
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        brightness: Brightness.dark,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: InkWell(
              customBorder: CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.search_rounded),
              ),
              onTap: () {},
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: _event(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            return Column(
              children: getSome(),
            );
          }
        ),
      ),
      drawer: DrawerScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NewEvents n = context.read<NewEvents>();
          n.increment();
        },
        child: Icon(Icons.edit_rounded),
      ),
    );
  }

  void eventArrives(String npub) {
    // This has to be called whenever we get signaled by stream
    if (npubs.contains(npub)) {
      // Put the blue dot indicating a new message arrived
    } else {
      // should go at the top of the displayed list
      npubs.add(npub);
    }
  }
}
