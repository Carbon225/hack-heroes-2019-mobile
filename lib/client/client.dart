import 'dart:async';
import 'dart:io';

import 'package:hack_heroes_mobile/client/Session.dart';
import 'package:hack_heroes_mobile/client/server_api.dart';

class AppClient {
  AppClient();

  void dispose() {
    _socket?.destroy();
    _session?.dispose();
    _socket = null;
    _session = null;
  }

  Future<void> getHelp(host, int port) async {
    if (_socket != null) {
      dispose();
    }

    _socket = await Socket.connect(host, port);
//    _socket.listen(
//      _onData,
//      onDone: _onDone,
//      onError: _onError,
//    );

    _socket.done.then(_onDone);
    _socket.handleError(_onError);

    try {
      _session = await ServerAPI.requestSession(_socket);
    }
    catch (e) {
      throw('Could not get session. $e');
    }

    print('Connected to peer');
    _session.sendText("hello?");
  }

  void _onData(data) {
    print('onData $data');
//    _socket.add([data[0] + 1]);
  }

  void _onDone(socket) {
    print('onDone $socket');
    socket?.destroy();
    _socket = null;
  }

  void _onError(error, StackTrace trace) {
    print(error);
  }

  Socket _socket;
  Session _session;
}