import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/events.dart';
import '../components/chats/chats_entry.dart';
import '../components/drawer/index.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({Key? key, this.title='Messages'}) : super(key: key);
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
        child: Consumer<NewEvents>(
          builder: (context, NewEvents e, child) {
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
}

