import 'package:flutter/material.dart';

import 'package:nostrim/screens/home.dart';
import 'package:nostrim/utils/color.dart';

import 'src/db/db.dart';


Future<void> main() async {
  final database = MyDatabase();
  runApp(Nostrim());
}

class Nostrim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nostrim',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: PacificBlue,
        accentColor: PacificBlue,
        brightness: Brightness.light,
      ),
      home: HomePage(title: 'Nostrim'),
    );
  }
}

Future<void> connect_to_relays() async {}
