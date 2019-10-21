import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hack_heroes_mobile/client/client.dart';
import 'package:hack_heroes_mobile/logic/firebase_notifications.dart';

class HelperCard extends StatefulWidget {
  final bool _fabMode;
  final Function _onHelpNeeded;

  HelperCard(this._onHelpNeeded) : _fabMode = false;
  HelperCard.fab(this._onHelpNeeded) : _fabMode = true;

  @override
  State<StatefulWidget> createState() => HelperCardState();
}

class HelperCardState extends State<HelperCard> with SingleTickerProviderStateMixin {

  AppClient _appClient;
  Animation<Offset> _fabAnimation;
  AnimationController _fabController;

  @override
  void initState() {
    _appClient = AppClient();

    _fabController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _fabAnimation = MaterialPointArcTween(begin: Offset.zero, end: Offset(1.2, 0)).animate(_fabController);

    FirebaseNotifications.onHelpNeeded(_checkHelp);

    _checkHelp();
    super.initState();
  }

  @override
  void dispose() {
    FirebaseNotifications.onHelpNeeded(null);
    _appClient?.dispose();
    super.dispose();
  }

  Future<void> _offerHelp() async {
    try {
//      await _appClient.offerHelp();
    }
    catch (e) {
      print(e);
    }
  }

  Future<void> _checkHelp() async {
    final helpRequest = await _appClient.helpNeeded();
    if (helpRequest == null) {
      print('Help not needed');
      return;
    }

    widget._onHelpNeeded(helpRequest);
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
          IconButton(
            onPressed: _offerHelp,
            alignment: Alignment.center,
            iconSize: 50,
            icon: Image.asset('assets/get_help.png'),
          ),
        ],
      ),
    );
  }

  Widget _fab(context) {
    return SlideTransition(
      position: _fabAnimation,
      child: FloatingActionButton.extended(
        onPressed: _checkHelp,
        icon: Transform(
          transform: Matrix4.translationValues(-11, 0, 0),
          child: Image.asset('assets/get_help.png',
            width: 40,
            height: 40,
          ),
        ),
        label: Text('Offer help'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget._fabMode ? _fab(context) : _card(context);
  }
}