import 'package:flutter_blue/flutter_blue.dart';

class BluetoothDeviceWrapper {
  BluetoothDeviceWrapper(BluetoothDevice device)
  : device = device;

  int get key {
    return device.id.id.hashCode;
  }

  final BluetoothDevice device;
}