import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NetworkStatsCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NetworkStatsCardState();
}

class NetworkStatsCardState extends State<NetworkStatsCard> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    print('STARTING FIREBASE PLSSSS WORK');
    _firebaseMessaging.configure(
//      onBackgroundMessage: (msg) async => print('BG msg'),
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

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
            Text('Network statistics',
              style: Theme.of(context).textTheme.title,
            ),
            Text('Not connected'),
          ],
        ),
      ),
    );
  }
}