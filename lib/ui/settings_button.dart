import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/ui/configurator_screen.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      // should show dialog
      onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ConfiguratorScreen(),
      )),
      icon: Icon(Icons.settings),
    );
  }
}