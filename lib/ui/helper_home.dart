import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/client/help_request.dart';
import 'package:hack_heroes_mobile/logic/firebase_notifications.dart';
import 'package:hack_heroes_mobile/ui/helper_card.dart';
import 'package:hack_heroes_mobile/ui/incoming_request.dart';
import 'package:hack_heroes_mobile/ui/settings_button.dart';

class HelperHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HelperHomeState();
}

class HelperHomeState extends State<HelperHome> {

  StreamController<HelpRequest> _receivingStream;

  @override
  void initState() {
    FirebaseNotifications.init();
    _receivingStream = StreamController<HelpRequest>();
    super.initState();
  }

  @override
  void dispose() {
    FirebaseNotifications.dispose();
    _receivingStream.close();
    super.dispose();
  }

  Future<void> _onHelpNeeded(HelpRequest request) async {
    _receivingStream.add(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helpnet'),
        actions: <Widget>[
          SettingsButton(),
        ],
      ),
      floatingActionButton: HelperCard.fab(_onHelpNeeded),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: IncomingRequest(_receivingStream.stream),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}