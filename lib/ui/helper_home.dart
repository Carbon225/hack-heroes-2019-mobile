import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/ui/helper_card.dart';
import 'package:hack_heroes_mobile/ui/helper_user_info.dart';
import 'package:hack_heroes_mobile/ui/network_stats_card.dart';
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
      floatingActionButton: HelperCard.fab(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          HelperUserInfo(),
          Expanded(
            child: Container(),
          ),
          NetworkStatsCard(),
        ],
      ),
    );
  }
}