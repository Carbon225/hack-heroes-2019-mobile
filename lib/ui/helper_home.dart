import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/ui/get_help_card.dart';
import 'package:hack_heroes_mobile/ui/helper_card.dart';
import 'package:hack_heroes_mobile/ui/helper_user_info.dart';
import 'package:hack_heroes_mobile/ui/settings_button.dart';

class HelperHome extends StatelessWidget {
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
          HelperUserInfo(),
          Row(
            children: <Widget>[
              Expanded(
                child: HelperCard(),
              ),
              Expanded(
                child: GetHelpCard(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}