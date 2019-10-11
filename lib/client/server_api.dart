import 'dart:io';

import 'package:hack_heroes_mobile/client/Session.dart';
import 'package:hack_heroes_mobile/client/packets.dart';

class ServerAPI {
  static Future<Session> requestSession(Socket socket) async {
    socket.add(Packets.requestSession);

    final data = await socket.first.timeout(Duration(seconds: 1));
    print('requestSession $data');

    try {
      if (Packets.command(data) == Commands.sessionFound) {
        print('Got session');
      }
      else {
        throw('Server did not create a session');
      }
    }
    on RangeError {
      throw('Unknown server command');
    }

    return Session(socket);
  }
}