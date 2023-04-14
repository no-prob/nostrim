import 'package:flutter/material.dart';

import '../components/chats/chats_entry.dart';
import '../components/drawer/index.dart';

class ChatsList extends StatefulWidget {
  ChatsList({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ChatsListState createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  bool showOtherUsers = false;
  int selectedUser = 0;

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
        child: Column(
          children: [
            ChatsEntry(
              name: "Flutter Developers",
              picture: NetworkImage(
                "https://i.ytimg.com/vi/D7h9UMADesM/maxresdefault.jpg",
              ),
              type: "group",
              sending: "Your",
              lastTime: "02:45",
              seeing: 2,
              lastMessage: "https://github.com",
            ),
            Divider(height: 0),
            ChatsEntry(
              name: "Flutter Türkiye 🇹🇷",
              picture: NetworkImage(
                "https://i.ytimg.com/vi/D7h9UMADesM/maxresdefault.jpg",
              ),
              lastTime: "02:16",
              type: "group",
              sending: "Mesud",
              lastMessage: "gece gece sinirim bozuldu.",
            ),
            Divider(height: 0),
          ],
        ),
      ),
      drawer: DrawerScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {print('hi');},
        child: Icon(Icons.edit_rounded),
      ),
    );
  }
}

