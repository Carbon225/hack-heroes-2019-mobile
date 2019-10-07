import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/ui/startup_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hack Heroes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartupScreen(),
    );
  }
}