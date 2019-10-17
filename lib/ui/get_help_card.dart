import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hack_heroes_mobile/client/client.dart';
import 'package:hack_heroes_mobile/client/connection_status.dart';
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

  static Future<List<int>> _imageToBytes(HelpImage image) async {
    if (await image.valid) {
      final file = File(image.path);
      return await file.readAsBytes();
    }
    else {
      throw('Image missing');
    }
  }

  String _lastText = '';
  HelpImage _lastImage = HelpImage.missing();
  CameraWrapper _camera;
  AppClient _appClient;
  AppClient _remoteClient;
  StreamController<HelpImage> _sendStream;
  ConnectionStatus _connectionStatus = ConnectionStatus.NotConnected;

  @override
  void initState() {
    _remoteClient = AppClient();
    _appClient = AppClient();
    _camera = CameraWrapper();

    _appClient.stateStream.listen((status) async {
      if (status == ConnectionStatus.Connected) {
        _appClient.session.sendText(_lastText);
        _appClient.session.sendImage(await _imageToBytes(_lastImage));
      }
      if (!mounted)
        return;
      setState(() => _connectionStatus = status);
    });

    _sendStream = StreamController<HelpImage>.broadcast();

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
      _lastImage = await _camera.takeImage();
      widget.keyboardStream.add('clear');
    }
    catch (e) {
      print(e);
    }
  }

  Future<void> _onKeyboardClear(String text) async {
    _lastText = text;
    _sendStream.add(_lastImage);
    await _appClient.getHelp();
    await Future.delayed(Duration(milliseconds: 100), _remoteClient.offerHelp);
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