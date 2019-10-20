import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/logic/braille_to_char.dart';
import 'package:hack_heroes_mobile/ui/braille_key.dart';

class BrailleKeyboard extends StatefulWidget {
  final Function onChar;
  final Stream<String> responseStream;

  BrailleKeyboard(this.onChar, this.responseStream);

  @override
  State<StatefulWidget> createState() => BrailleKeyboardState();
}

class BrailleKeyboardState extends State<BrailleKeyboard> {

  var _buttonStates = List<int>.filled(6, 0);
  var _char = List<int>.filled(6, 0);

  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = widget.responseStream.listen((response) async {
      if (response == 'clear') {
        // ignore clear meant for the response display (top widget)
        return;
      }
      print('Keyboard print $response');
      for (final char in response.split('')) {
        setState(() {
          _buttonStates = charToBraille(char);
        });
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          _buttonStates.fillRange(0, 6, 0);
        });
        await Future.delayed(Duration(milliseconds: 500));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _handleMultiTouch(int id, var event) {
    if (event is TapDownDetails) {
      _char[id] = 1;
      setState(() {
        _buttonStates[id] = 1;
      });
    }
    else if (event is TapUpDetails || event == null) {
      setState(() {
        _buttonStates[id] = 0;
      });

      // all released
      if (_buttonStates.indexOf(1) == -1) {
        // - means backspace
        var char = BrailleToChar[_char.join()];
        if (char == null) {
          if (id == 2) {
            char = ' ';
          }
          else if (id == 3) {
            char = '-';
          }
        }
        widget.onChar(char);

        _char.fillRange(0, 6, 0);
      }
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BrailleKey(0, 'Key A', _handleMultiTouch, _buttonStates[0] == 1),
                  Align(
                    alignment: Alignment.center,
                    child: BrailleKey(1, 'Key B', _handleMultiTouch, _buttonStates[1] == 1),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: BrailleKey(2, 'Key C', _handleMultiTouch, _buttonStates[2] == 1),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: BrailleKey(3, 'Key D', _handleMultiTouch, _buttonStates[3] == 1),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: BrailleKey(4, 'Key E', _handleMultiTouch, _buttonStates[4] == 1),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BrailleKey(5, 'Key F', _handleMultiTouch, _buttonStates[5] == 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}