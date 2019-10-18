import 'dart:io';

import 'package:hack_heroes_mobile/client/server_options.dart';

class Session {
  Session(this.id);

  Future<void> connect() async {
    print('Connecting to ws://${ServerOptions.Host}:${ServerOptions.Port}${ServerOptions.WebSocket}');
    _socket = await WebSocket.connect('wss://${ServerOptions.Host}:${ServerOptions.Port}${ServerOptions.WebSocket}');
    print('WS connected');
    _socket.listen(
      _onData,
      onDone: _onDone,
      onError: _onError,
    );
    _socket.add(id);
  }

  Future<void> _onData(data) async {
    print('WS data $data');
  }

  Future<void> _onDone() async {
    print('WS done');
    await _socket?.close();
  }

  Future<void> _onError(error) async {
    print('WS error $error');
    await _socket?.close();
  }

  final String id;
  WebSocket _socket;
}