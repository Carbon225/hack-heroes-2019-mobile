import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hack_heroes_mobile/client/Session.dart';
import 'package:hack_heroes_mobile/client/packets.dart';
import 'package:hack_heroes_mobile/client/server_api.dart';
import 'package:hack_heroes_mobile/client/server_options.dart';


class AppClient {
  AppClient();

  void dispose() {
    _socket?.destroy();
    _session?.dispose();
    _socket = null;
    _session = null;
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
    await ServerAPI.offerHelp(_socket);
    print('Offered help');
  }

  Future<void> getHelp() async {
    await connect();
    await ServerAPI.requestSession(_socket);
    print('Asked for help');
  }

  void _onData(List<int> data) async {
    print('onData ${Packets.command(data)}');
    switch (Packets.command(data)) {
      case Commands.helpWanted:
        await ServerAPI.connectToPeer(_socket);
        break;

      case Commands.helpNotWanted:
        print('Help not wanted');
        dispose();
        break;

      case Commands.sessionFound:
        await ServerAPI.pipeTest(_socket);
        Future.delayed(Duration(seconds: 1), () {
          if (_session == null) {
            dispose();
            throw('Error creating session');
          }
        });
        break;

      case Commands.sessionNotFound:
        print('Session not found');
        dispose();
        break;

      case Commands.pipeTest:
        if (_session == null ) {
          await ServerAPI.pipeTest(_socket);
          _session = Session(_socket);
          print('SESSION CREATED');
          _session.sendText('Message');
        }
        break;

      case Commands.text:
        print('Got message: ${utf8.decode(data.sublist(1))}');
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

  Socket _socket;
  Session _session;
}