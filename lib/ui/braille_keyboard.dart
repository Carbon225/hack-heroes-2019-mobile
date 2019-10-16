import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/ui/braille_key.dart';

class BrailleKeyboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BrailleKeyboardState();
}

class BrailleKeyboardState extends State<BrailleKeyboard> {

  var _buttonStates = List<bool>.filled(6, false);

  void _handleMultiTouch(int id, var event) {
    if (event is TapDownDetails) {
      print('$id pressed');
      setState(() {
        _buttonStates[id] = true;
      });
    }
    else if (event is TapUpDetails || event == null) {
      print('$id released');
      setState(() {
        _buttonStates[id] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                BrailleKey(0, 'Key A', _handleMultiTouch, _buttonStates[0]),
                Container(height: 5),
                BrailleKey(1, 'Key B', _handleMultiTouch, _buttonStates[1]),
                Container(height: 5),
                BrailleKey(2, 'Key C', _handleMultiTouch, _buttonStates[2]),
              ],
            ),
            Column(
              children: <Widget>[
                BrailleKey(3, 'Key D', _handleMultiTouch, _buttonStates[3]),
                Container(height: 5),
                BrailleKey(4, 'Key E', _handleMultiTouch, _buttonStates[4]),
                Container(height: 5),
                BrailleKey(5, 'Key F', _handleMultiTouch, _buttonStates[5]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}