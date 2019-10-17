import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hack_heroes_mobile/client/Session.dart';
import 'package:hack_heroes_mobile/client/connection_status.dart';
import 'package:hack_heroes_mobile/client/packets.dart';
import 'package:hack_heroes_mobile/client/server_api.dart';
import 'package:hack_heroes_mobile/client/server_options.dart';


class AppClient {
  AppClient();

  void dispose() {
//    _connectionStatus.close();
    _socket?.destroy();
    _session?.dispose();
    _socket = null;
    _session = null;
    _receivingImage = false;

    Future.delayed(Duration(seconds: 3), () => _connectionStatus.add(ConnectionStatus.NotConnected));
  }

  Session get session {
    return _session;
  }

  Future<void> connect() async {
    if (_socket != null) {
      dispose();
    }

    _socket = await Socket.connect(ServerOptions.address, ServerOptions.port);
    _socket.listen(
      _onData,
      onDone: _onDone,
      onError: _onError,
    );
  }

  Future<void> offerHelp() async {
    await connect();
    _connectionStatus.add(ConnectionStatus.OfferingHelp);
    await ServerAPI.offerHelp(_socket);
    print('Offered help');
  }

  Future<void> getHelp() async {
    await connect();
    _connectionStatus.add(ConnectionStatus.RequestingSession);
    await ServerAPI.requestSession(_socket);
    print('Asked for help');
  }

  void _onData(List<int> data) async {
    print('onData ${Packets.command(data)}');

    final command = _receivingImage ? Commands.image : Packets.command(data);

    switch (command) {
      case Commands.helpWanted:
        _connectionStatus.add(ConnectionStatus.ConnectingToPeer);
        await ServerAPI.connectToPeer(_socket);
        break;

      case Commands.helpNotWanted:
        print('Help not wanted');
        _connectionStatus.add(ConnectionStatus.HelpNotWanted);
        dispose();
        break;

      case Commands.sessionFound:
        _connectionStatus.add(ConnectionStatus.TestingPipe);
        await ServerAPI.pipeTest(_socket);
        Future.delayed(Duration(seconds: 1), () {
          if (_session == null) {
            _connectionStatus.add(ConnectionStatus.BrokenPipe);
            dispose();
            throw('Error creating session');
          }
        });
        break;

      case Commands.sessionNotFound:
        print('Session not found');
        _connectionStatus.add(ConnectionStatus.SessionNotFound);
        dispose();
        break;

      case Commands.pipeTest:
        if (_session == null ) {
          await ServerAPI.pipeTest(_socket);
          _session = Session(_socket);
          print('SESSION CREATED');
          _connectionStatus.add(ConnectionStatus.Connected);
//          _session.sendText('Message');
        }
        break;

      case Commands.text:
        print('Got message: ${utf8.decode(data.sublist(1))}');
        break;

      case Commands.imageStart:
        print('Image start');
        _receivingImage = true;
        _imageBuffer = data.sublist(1);
        break;

      case Commands.image:
        if (data.last == Commands.imageStop.index) {
          data.removeLast();
          print('Image end');
          _receivingImage = false;
        }
        else {
          print('Image data');
        }
        _imageBuffer.addAll(data);
        break;

      default:
        throw('Unknown command');
    }
  }

  void _onDone() {
    print('onDone');
    dispose();
  }

  void _onError(error, StackTrace trace) {
    print(error);
    dispose();
  }

  Stream<ConnectionStatus> get stateStream {
    return _connectionStatus.stream;
  }

  final _connectionStatus = StreamController<ConnectionStatus>();

  bool _receivingImage = false;
  List<int> _imageBuffer = List<int>();

  Socket _socket;
  Session _session;
}