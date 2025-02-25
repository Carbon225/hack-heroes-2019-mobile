import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/bluetooth/ble_keyboard.dart';
import 'package:hack_heroes_mobile/logic/firebase_notifications.dart';
import 'package:hack_heroes_mobile/logic/user_settings.dart';
import 'package:hack_heroes_mobile/ui/braille_keyboard.dart';
import 'package:hack_heroes_mobile/ui/get_help_card.dart';
import 'package:hack_heroes_mobile/ui/keyboard_log.dart';
import 'package:hack_heroes_mobile/ui/settings_button.dart';

class BlindHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BlindHomeState();
}

class BlindHomeState extends State<BlindHome> {

  StreamController<String> _keyboardController;
  StreamController<String> _responseController;

  BluetoothKeyboard _bleKeyboard;

  @override
  void initState() {
    _keyboardController = StreamController<String>();
    _responseController = StreamController<String>.broadcast();

    _bleKeyboard = BluetoothKeyboard();
    _bleKeyboard.connect(UserSettings.keyboardID);

    FirebaseNotifications.init();

    super.initState();
  }

  @override
  void dispose() {
    FirebaseNotifications.dispose();
    _bleKeyboard.dispose();
    _keyboardController.close();
    _responseController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helpnet'),
        actions: <Widget>[
          SettingsButton(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          KeyboardLog(_responseController.stream.map((text) {
            if (text != 'clear') {
              Future.delayed(Duration(seconds: 3), () => _responseController.add('clear'));
            }
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