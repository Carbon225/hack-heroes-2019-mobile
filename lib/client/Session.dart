import 'dart:io';

import 'package:hack_heroes_mobile/client/packets.dart';

class Session {
  Session(this._socket);

  void dispose() {
    _socket?.destroy();
  }

  void sendText(String msg) {
    _socket.add(Packets.sendText(msg));
  }

  void sendImage(List<int> image) {
    _socket.add(Packets.sendImage(image));
  }

  Socket _socket;
}