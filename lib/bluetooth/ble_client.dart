import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothClient {

  void dispose() {
    _blue.stopScan();
  }

  Stream<BluetoothDevice> scan() {
    return _blue.scan().map((result) => result.device);
  }

  void stopScan() {
    _blue.stopScan();
  }

  final FlutterBlue _blue = FlutterBlue.instance;
}