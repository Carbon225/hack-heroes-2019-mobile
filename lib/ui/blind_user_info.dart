import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BlindUserInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BlindUserInfoState();
}

class BlindUserInfoState extends State<BlindUserInfo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Info',
              style: Theme.of(context).textTheme.title,
            ),
          ],
        ),
      ),
    );
  }
}