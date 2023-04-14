import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'screens/chats_list.dart';
import 'utils/color.dart';
import 'src/db/db.dart';

Future<void> main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NewEvents(),
      child: MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Nostrim');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class NewEvents with ChangeNotifier {
  // Idea is for this class to get the new messages and
  // notify the chatsList and the conversationLists
  // terms:
  // ChatsList - list of all the chats - Messages screen
  // ChatsEntry - an entry in the ChatsList
  // ConversationList - contains the conversation exchange of a single chat - screen (name of chat peer)
  // ConversationEntry - an entry in the ConversationList
  // ChannelsList - list of all the channels - Channels screen
  // ChannelsEntry - an entry in the ChannelsList
  // ChannelConversationList - contains the conversation exchange of a single channel - Channels screen
  // ChannelConversationEntry - an entry in the ChannelConversationList (name of the channel)
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nostrim',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: PacificBlue,
        brightness: Brightness.dark, // light
        accentColor: PacificBlue,
      ),
      home: ChatsList(title: 'Messages'),
    );
  }
}
