/* Packet structure

 0    - command
 1-n  - data

 */

import 'dart:convert';


enum Commands {
  unknown,
  requestSession,
  sessionFound,
  sessionNotFound,
  text,
  imageStart,
  image,
  imageStop,
  offerHelp,
  helpWanted,
  helpNotWanted,
  connectToPeer,
  pipeTest,
}

class Packets {

  static final List<int> requestSession = [
    Commands.requestSession.index,
  ];

  static final List<int> offerHelp = [
    Commands.offerHelp.index,
  ];

  static final List<int> connectToPeer = [
    Commands.connectToPeer.index,
  ];

  static final List<int> pipeTest = [
    Commands.pipeTest.index,
  ];

  static List<int> sendText(String msg) {
    final packet = [Commands.text.index];
    packet.addAll(utf8.encode(msg));
    return packet;
  }

  static List<int> sendImage(List<int> image) {
    final packet = [Commands.imageStart.index];
    packet.addAll(image);
    packet.add(Commands.imageStop.index);
    return packet;
  }

  static Commands command(List<int> packet) {
    try {
      return Commands.values[packet[0]];
    }
    on RangeError {
      return Commands.unknown;
    }
  }
}