import 'package:flutter/material.dart';
import 'package:nostrim/screens/home.dart';
import 'package:nostrim/utils/color.dart';

void main() {
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
