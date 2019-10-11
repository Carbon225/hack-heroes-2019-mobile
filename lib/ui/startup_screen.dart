import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/logic/app_mode.dart';
import 'package:hack_heroes_mobile/logic/user_settings.dart';
import 'package:hack_heroes_mobile/ui/configurator_screen.dart';
import 'package:hack_heroes_mobile/ui/blind_home.dart';
import 'package:hack_heroes_mobile/ui/helper_home.dart';

class StartupScreen extends StatelessWidget {
  Widget _startupScreen(BuildContext context, AsyncSnapshot snapshot) {

    // loading indicator while getting user settings
    if (snapshot.connectionState != ConnectionState.done) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Hack Heroes'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // go to home screen for the selected mode
    if (!UserSettings.firstRun) {
      switch (UserSettings.mode) {
        case AppMode.Blind:
          return BlindHome();

        case AppMode.Helper:
          return HelperHome();

        default:
          return Text('How did you choose a nonexistent mode???');
      }
    }

    // first time setup
    return ConfiguratorScreen();
  }

  Future<void> _setup() async {
    await UserSettings.load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: _startupScreen,
      future: _setup(),
    );
  }
}