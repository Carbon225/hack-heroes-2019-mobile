import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/ui/blind_user_info.dart';
import 'package:hack_heroes_mobile/ui/braille_keyboard.dart';
import 'package:hack_heroes_mobile/ui/get_help_card.dart';
import 'package:hack_heroes_mobile/ui/network_stats_card.dart';
import 'package:hack_heroes_mobile/ui/settings_button.dart';

class BlindHome extends StatelessWidget {
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
          BlindUserInfo(),
          Expanded(
            child: GetHelpCard(),
          ),
          BrailleKeyboard(),
//          NetworkStatsCard(),
        ],
      ),
    );
  }
}