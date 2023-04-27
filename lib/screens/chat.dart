import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nostr/nostr.dart';

import '../models/events.dart';
import '../models/message_entry.dart';
import '../components/chats/chats_entry.dart';
import '../components/drawer/index.dart';
import '../constants/messages.dart';
import '../src/db/crud.dart';
import '../../config/settings.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.npub, this.title='Messages with specific peer'}) : super(key: key);
  final String title;
  final String? npub;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  DateTime? lastSeen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        //backgroundColor: Colors.white, // white for light mode
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                ),
                SizedBox(width: 2,),
                CircleAvatar(
                  backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/5.jpg"),
                  maxRadius: 20,
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Kriss Benwat",style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                      SizedBox(height: 6,),
                      Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                    ],
                  ),
                ),
                Icon(Icons.settings,color: Colors.black54,),
              ],
            ),
          ),
        ),
      ),
      //body: CustomMultiChildLayout(
      body: Stack(
        //delegate: MultiChildLayoutDelegate(),
        children: <Widget>[
          StreamBuilder(
            stream: watchMessages(),
            builder: (context, AsyncSnapshot<List<MessageEntry>> snapshot) {
              if (snapshot.hasData) {
                addMessages(snapshot.data!);

                return ListView.builder(
                  //itemExtent: 
                  itemCount: messages.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                      child: Align(
                        alignment: (messages[index].type == "receiver" ? Alignment.topLeft:Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (messages[index].type  == "receiver" ? Colors.grey.shade400:Colors.blue[400]),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(messages[index].content, style: TextStyle(fontSize: 15),),
                        ),
                      ),
                    );
                  },
                );
              }
              return const LinearProgressIndicator();
            }
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              //color: Colors.white, // white for light mode
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: () {},
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addMessages(List<MessageEntry> entries) {
    for (final message in entries) {
      if (lastSeen == null || message.timestamp.isAfter(lastSeen!)) {
        lastSeen = message.timestamp;
      }
      messages.add(message);
    }
  }
}

List<MessageEntry> messages = [];
