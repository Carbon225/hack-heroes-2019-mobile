import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothClient {

  BluetoothClient() {
    _stateSub = _blue.state.listen((state) => _state = state);

    // something is wrong
    _scanSub = _blue.isScanning.listen((scanning) => _isScanning = isScanning);
  }

  void dispose() {
    _stateSub?.cancel();
    _scanSub?.cancel();
    _blue.stopScan();
  }

  Future<Stream<BluetoothDevice>> scan() async {
    print('Scanning BLE');
    await _blue.stopScan();
    return _blue.scan().map((result) => result.device);
  }

  void stopScan() {
    _blue.stopScan();
  }

  bool get isScanning {
    return _isScanning;
  }

  BluetoothState get state {
    return _state;
  }

  FlutterBlue get blue {
    return _blue;
  }

  final FlutterBlue _blue = FlutterBlue.instance;

  StreamSubscription _stateSub;
  StreamSubscription _scanSub;

  BluetoothState _state = BluetoothState.off;
  bool _isScanning = false;
}