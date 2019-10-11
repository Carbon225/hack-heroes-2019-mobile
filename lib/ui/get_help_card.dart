import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hack_heroes_mobile/client/client.dart';
import 'package:hack_heroes_mobile/client/server_options.dart';

class GetHelpCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GetHelpCardState();
}

class GetHelpCardState extends State<GetHelpCard> {

  final _appClient = AppClient();

  @override
  void dispose() {
    _appClient.dispose();
    super.dispose();
  }

  Future<void> _getHelp() async {
    try {
      await _appClient.getHelp(ServerOptions.address, ServerOptions.port);
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              onPressed: _getHelp,
              alignment: Alignment.center,
              iconSize: 200,
              tooltip: 'Call for help',
              icon: Image.asset('assets/get_help.png'),
          ),
          Text('Call for help',
            style: Theme.of(context).textTheme.title,
          )
        ],
      ),
    );
  }
}