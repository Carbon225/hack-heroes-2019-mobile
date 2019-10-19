import 'dart:async';
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
    _timer = Timer.periodic(Duration(seconds: 1), (t) => _keepAlive());
  }

  Future<String> get response {
    return _outputStream.stream.first;
  }

  void dispose() {
    _outputStream?.close();
    _timer?.cancel();
    _socket?.close();
  }

  void _keepAlive() {
    _socket?.add(id);
  }

  Future<void> _onData(data) async {
    print('WS data $data');
    _outputStream.add(data);
    _onDone();
  }

  Future<void> _onDone() async {
    print('WS done');
    await _socket?.close();
    _timer?.cancel();
  }

  Future<void> _onError(error) async {
    print('WS error $error');
    await _socket?.close();
    _timer?.cancel();
  }

  final String id;
  WebSocket _socket;
  Timer _timer;
  final _outputStream = StreamController<String>();
}