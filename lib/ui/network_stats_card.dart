import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NetworkStatsCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NetworkStatsCardState();
}

class NetworkStatsCardState extends State<NetworkStatsCard> {
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