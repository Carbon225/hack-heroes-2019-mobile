import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hack_heroes_mobile/client/client.dart';
import 'package:hack_heroes_mobile/logic/camera_controller.dart';
import 'package:hack_heroes_mobile/logic/help_image.dart';
import 'package:hack_heroes_mobile/ui/keyboard_log.dart';
import 'package:hack_heroes_mobile/ui/send_letter.dart';

class GetHelpCard extends StatefulWidget {
  final StreamController<String> keyboardStream;

  GetHelpCard(this.keyboardStream);

  @override
  State<StatefulWidget> createState() => GetHelpCardState();
}

class GetHelpCardState extends State<GetHelpCard> {

  String _lastText = '';
  CameraWrapper _camera;
  AppClient _appClient;
  AppClient _remoteClient;
  StreamController<HelpImage> _sendStream;

  @override
  void initState() {
    _remoteClient = AppClient();
    _appClient = AppClient();
    _camera = CameraWrapper();

    _sendStream = StreamController<HelpImage>();

    // prevents animation lag
    Future.delayed(Duration(milliseconds: 200), _camera.init);

    super.initState();
  }

  @override
  void dispose() {
    _remoteClient.dispose();
    _appClient.dispose();
    _camera.dispose();
    _sendStream.close();
    super.dispose();
  }

  Future<void> _getHelp() async {
    try {
      await _camera.initialized;
      final image = await _camera.takeImage();
      _sendStream.add(image);
      widget.keyboardStream.add('clear');
      await Future.delayed(Duration(milliseconds: 10), () async {
        print('Getting session');
        await _appClient.getHelp(_lastText, image);
        final response = await _appClient.response;
        print('Got help $response');
      });
    }
    catch (e) {
      print('Error getting session: $e');
    }
  }

  Future<void> _onKeyboardClear(String text) async {
    _lastText = text;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
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
                ),
              ],
            ),
          ),
          KeyboardLog(widget.keyboardStream.stream, _onKeyboardClear),
        ],
      ),
    );
  }
}