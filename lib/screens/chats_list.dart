import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
