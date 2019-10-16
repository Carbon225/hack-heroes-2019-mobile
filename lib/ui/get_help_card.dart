import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hack_heroes_mobile/client/client.dart';
import 'package:hack_heroes_mobile/client/connection_status.dart';
import 'package:hack_heroes_mobile/logic/camera_controller.dart';
import 'package:hack_heroes_mobile/logic/help_image.dart';
import 'package:hack_heroes_mobile/ui/send_letter.dart';

class GetHelpCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GetHelpCardState();
}

class GetHelpCardState extends State<GetHelpCard> {

  final _camera = CameraWrapper();
  final _appClient = AppClient();
  StreamController<HelpImage> _sendStream;
  ConnectionStatus _connectionStatus = ConnectionStatus.NotConnected;

  @override
  void initState() {
    _appClient.stateStream.listen((status) {
      if (status == ConnectionStatus.NotConnected) {
        ;
      }
      if (!mounted)
        return;
      setState(() => _connectionStatus = status);
    });

    _sendStream = StreamController<HelpImage>.broadcast();
    _camera.init();

    super.initState();
  }

  @override
  void dispose() {
    _appClient.dispose();
    _sendStream.close();
    super.dispose();
  }

  Future<void> _getHelp() async {
    try {
      await _camera.initialized;
      final image = await _camera.takeImage();
      _sendStream.add(image);
      await _appClient.getHelp();
    }
    catch (e) {
      print(e);
    }
  }

  bool _showSender() {
    switch (_connectionStatus) {
      case ConnectionStatus.RequestingSession:
      case ConnectionStatus.ConnectingToPeer:
      case ConnectionStatus.Connected:
      case ConnectionStatus.TestingPipe:
      case ConnectionStatus.NotConnected:
        return true;

      default:
        return false;
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
          Text(_connectionStatus.toString().split('.').last),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              IconButton(
                onPressed: _getHelp,
                alignment: Alignment.center,
                iconSize: 200,
                tooltip: 'Call for help',
                icon: Image.asset('assets/get_help.png'),
              ),
              SendLetter(_sendStream.stream),
            ],
          ),
          Text('Call for help',
            style: Theme.of(context).textTheme.title,
          )
        ],
      ),
    );
  }
}