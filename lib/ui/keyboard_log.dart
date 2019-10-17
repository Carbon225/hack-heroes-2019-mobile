import 'dart:async';

import 'package:flutter/material.dart';

class KeyboardLog extends StatefulWidget {
  final Stream<String> inputStream;
  final Function _onClear;

  KeyboardLog(this.inputStream, this._onClear);

  @override
  State<StatefulWidget> createState() => KeyboardLogState();
}

class KeyboardLogState extends State<KeyboardLog> with SingleTickerProviderStateMixin {

  StreamSubscription _streamSubscription;
  String _text = '';

  @override
  void initState() {
    _streamSubscription = widget.inputStream.listen((c) {
      if (c == '-') {
        if (_text.length == 1) {
          _text = '';
        }
        else {
          _text = _text.substring(0, _text.length - 2);
        }
        c = '';
      }
      else if (c == 'clear') {
        widget._onClear(_text);
        _text = '';
        c = '';
      }

      setState(() {
        _text += c;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(Size.fromHeight( _text.isEmpty ? 0 : 100)),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(_text),
          ),
        ),
      ),
    );
  }
}