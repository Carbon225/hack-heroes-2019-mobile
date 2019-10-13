import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hack_heroes_mobile/client/client.dart';
import 'package:hack_heroes_mobile/client/connection_status.dart';

class HelperCard extends StatefulWidget {
  final bool _fabMode;

  HelperCard() : _fabMode = false;
  HelperCard.fab() : _fabMode = true;

  @override
  State<StatefulWidget> createState() => HelperCardState();
}

class HelperCardState extends State<HelperCard> with SingleTickerProviderStateMixin {

  final _appClient = AppClient();
  StreamSubscription _stateSub;
  ConnectionStatus _connectionStatus = ConnectionStatus.NotConnected;

  Animation<Offset> _fabAnimation;
  AnimationController _fabController;

  @override
  void initState() {
    super.initState();

    _fabController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _fabAnimation = MaterialPointArcTween(begin: Offset.zero, end: Offset(1.2, 0)).animate(_fabController);

    _stateSub = _appClient.stateStream.listen((state) {
      if (state == ConnectionStatus.Connected) {
        _fabController.forward();
      }
      else {
        _fabController.reverse();
      }

      setState(() => _connectionStatus = state);
    });
  }

  @override
  void dispose() {
    _appClient?.dispose();
    _stateSub?.cancel();
    super.dispose();
  }

  Future<void> _offerHelp() async {
    try {
      await _appClient.offerHelp();
    }
    catch (e) {
      print(e);
    }
  }

  String _getStatusText(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.HelpNotWanted:
        return 'Not needed';

      default:
        return 'Offer help';
    }
  }

  Widget _card(context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          Text(_getStatusText(_connectionStatus)),
          IconButton(
            onPressed: _connectionStatus == ConnectionStatus.NotConnected ? _offerHelp : null,
            alignment: Alignment.center,
            iconSize: 50,
            icon: Image.asset('assets/get_help.png'),
          ),
//          Text('Offer help',
//            style: Theme.of(context).textTheme.title,
//          )
        ],
      ),
    );
  }
  Widget _fab(context) {
    return SlideTransition(
      position: _fabAnimation,
      child: FloatingActionButton.extended(
        onPressed: _connectionStatus == ConnectionStatus.NotConnected ? _offerHelp : null,
        icon: Transform(
          transform: Matrix4.translationValues(-10, 0, 0),
          child: Image.asset('assets/get_help.png',
            width: 40,
            height: 40,
          ),
        ),
        label: Text(_getStatusText(_connectionStatus)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget._fabMode ? _fab(context) : _card(context);
  }
}