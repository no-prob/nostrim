import 'package:flutter/material.dart';
import 'package:nostrim/components/home/UserMessage.dart';
import 'package:nostrim/components/home/drawer/index.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            UserMessage(
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
            UserMessage(
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
        onPressed: () {},
        child: Icon(Icons.edit_rounded),
      ),
    );
  }
}
