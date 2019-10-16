import 'dart:async';

import 'package:flutter/material.dart';

class KeyboardLog extends StatefulWidget {
  final Stream<String> inputStream;

  KeyboardLog(this.inputStream);

  @override
  State<StatefulWidget> createState() => KeyboardLogState();
}

class KeyboardLogState extends State<KeyboardLog> with SingleTickerProviderStateMixin {

  StreamSubscription _streamSubscription;
  String _text = '';

  @override
  void initState() {
    _streamSubscription = widget.inputStream.listen((c) {
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
        duration: Duration(milliseconds: 50),
        curve: Curves.easeInOut,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(_text),
        ),
      ),
    );
  }
}