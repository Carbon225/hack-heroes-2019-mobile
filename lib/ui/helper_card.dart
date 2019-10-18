import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hack_heroes_mobile/client/client.dart';

class HelperCard extends StatefulWidget {
  final bool _fabMode;

  HelperCard() : _fabMode = false;
  HelperCard.fab() : _fabMode = true;

  @override
  State<StatefulWidget> createState() => HelperCardState();
}

class HelperCardState extends State<HelperCard> with SingleTickerProviderStateMixin {

  final _appClient = AppClient();
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
  }

  @override
  void dispose() {
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
        onPressed: _offerHelp,
        icon: Transform(
          transform: Matrix4.translationValues(-10, 0, 0),
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