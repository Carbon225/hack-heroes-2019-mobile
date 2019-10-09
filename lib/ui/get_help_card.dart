import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GetHelpCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GetHelpCardState();
}

class GetHelpCardState extends State<GetHelpCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              onPressed: () {},
              alignment: Alignment.center,
              iconSize: 150,
              tooltip: 'Call for help',
              icon: Ink(
                width: 150,
                height: 150,
                child: Image.network('https://img.icons8.com/color/96/000000/siren.png',
                  fit: BoxFit.contain,
                ),
              )
          ),
          Text('Call for help',
            style: Theme.of(context).textTheme.title,
          )
        ],
      ),
    );
  }
}