import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'screens/home.dart';
import 'utils/color.dart';
import 'src/db/db.dart';

Future<void> main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NewMessages(),
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

class NewMessages with ChangeNotifier {
  // Idea is for this class to get the new messages and
  // notify the chatsList and the conversationLists
  // terms:
  // ChatsScreen - list of all the chats
  // ChannelsScreen - list of all the channels
  // ConversationScreen - contains the conversation exchange of a single chat
  // ChannelConversationScreen - contains the conversation exchange of a single channel
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
      home: HomePage(title: 'Nostrim'),
    );
  }
}
