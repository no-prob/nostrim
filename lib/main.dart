import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'utils/color.dart';

void main() {
  runApp(TelegramClone());
}

class TelegramClone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: PacificBlue,
        accentColor: PacificBlue,
        brightness: Brightness.light,
      ),
      home: HomePage(title: 'Telegram'),
    );
  }
}
