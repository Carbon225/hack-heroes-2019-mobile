import 'package:flutter/material.dart';
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
          Text('you are help'),
        ],
      ),
    );
  }
}