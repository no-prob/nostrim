import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'models/events.dart';
import 'screens/chats_list.dart';
import 'screens/chat.dart';
import 'screens/channels_list.dart';
import 'screens/channel.dart';
import 'screens/contacts_list.dart';
import 'screens/contact.dart';
import 'constants/color.dart';
import 'src/db/db.dart' as db;

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

GoRouter router() {
  return GoRouter(
    initialLocation: '/chats',
    routes: [
      GoRoute(
        path: '/chats',
        builder: (context, state) => const ChatsList(),
        routes: [
          GoRoute(
            path: 'chat/:npub',
            name: 'chat',
            builder: (context, state) => Chat(
              npub: state.params['npub'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/channels',
        builder: (context, state) => const ChannelsList(),
        routes: [
          GoRoute(
            path: 'channel/:npub', // look up nip28 channels
            name: 'channel',
            builder: (context, state) => Channel(
              npub: state.params['npub'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/contacts',
        builder: (context, state) => const ContactsList(),
        routes: [
          GoRoute(
            path: 'contact/:npub',
            name: 'contact',
            builder: (context, state) => Contact(
              npub: state.params['npub'],
            ),
          ),
        ],
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nostrim',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: PacificBlue,
        brightness: Brightness.dark, // light
        accentColor: PacificBlue,
      ),
      routerConfig: router(),
    );
  }
}
