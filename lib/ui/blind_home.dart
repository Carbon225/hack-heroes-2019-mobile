import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/logic/user_settings.dart';
import 'package:hack_heroes_mobile/ui/blind_user_info.dart';
import 'package:hack_heroes_mobile/ui/braille_keyboard.dart';
import 'package:hack_heroes_mobile/ui/get_help_card.dart';
import 'package:hack_heroes_mobile/ui/keyboard_log.dart';
import 'package:hack_heroes_mobile/ui/network_stats_card.dart';
import 'package:hack_heroes_mobile/ui/settings_button.dart';

class BlindHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BlindHomeState();
}

class BlindHomeState extends State<BlindHome> {

  StreamController<String> _keyboardController;
  StreamController<String> _responseController;

  @override
  void initState() {
    _keyboardController = StreamController<String>();
    _responseController = StreamController<String>.broadcast();

    super.initState();
  }

  @override
  void dispose() {
    _keyboardController.close();
    _responseController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App title'),
        actions: <Widget>[
          SettingsButton(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          KeyboardLog(_responseController.stream.map((text) {
            Future.delayed(Duration(seconds: 3), () => _responseController.add('clear'));
            return text;
          }), (text) {}),
          Expanded(
            child: GetHelpCard(
              _keyboardController,
              _responseController.add
            ),
          ),
          UserSettings.demoMode ? BrailleKeyboard(
            _keyboardController.add,
            _responseController.stream,
          ) : Container(),
        ],
      ),
    );
  }
}