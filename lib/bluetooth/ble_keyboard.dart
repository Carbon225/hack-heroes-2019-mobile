import 'package:flutter_blue/flutter_blue.dart';

class BluetoothKeyboard {
  BluetoothKeyboard();

  void dispose() {
    _ble.stopScan();
  }

  Future<void> connect(String id) async {
    BluetoothDevice device;

    print('Connecting to $id');
    await _ble.stopScan();

    try {
      device = (await _ble.connectedDevices).firstWhere((d) => d.id.id == id);
    }
    on StateError {}

    if (device == null) {
      device = (await _ble.scan().firstWhere(
              (result) => result.device.id.id == id)
      ).device;

      await device.connect();
    }

    print('Connected');
    print('Discovering services');
    final services = await device.discoverServices();
    final txService = services.firstWhere((service) =>
        service.uuid.toString().toLowerCase().startsWith('6e40'));

    print('Discovering characteristics');
    for (BluetoothCharacteristic char in txService.characteristics) {
      print('Characteristic ${char.uuid.toString()}');
      if (char.uuid.toString().toLowerCase().startsWith('6e400002')) {
        _txCharacteristic = char;
      }
      else if (char.uuid.toString().toLowerCase().startsWith('6e400003')) {
        _rxCharacteristic = char;
      }
    }
  }

  Future<void> send(String text) async {
  }

  void onCharacter(Function cb) {
    _onCharacter = cb;
  }

  final _ble = FlutterBlue.instance;
  BluetoothCharacteristic _txCharacteristic;
  BluetoothCharacteristic _rxCharacteristic;
  Function _onCharacter;
}