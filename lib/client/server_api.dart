import 'dart:io';

import 'package:hack_heroes_mobile/client/packets.dart';

class ServerAPI {
  static Future<void> requestSession(Socket socket) async {
    socket.add(Packets.requestSession);
  }

  static Future<void> offerHelp(Socket socket) async {
    socket.add(Packets.offerHelp);
  }

  static Future<void> connectToPeer(Socket socket) async {
    socket.add(Packets.connectToPeer);
  }

  static Future<void> pipeTest(Socket socket) async {
    socket.add(Packets.pipeTest);
  }
}