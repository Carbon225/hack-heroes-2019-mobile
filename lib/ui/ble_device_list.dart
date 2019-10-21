import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/bluetooth/ble_client.dart';
import 'package:hack_heroes_mobile/bluetooth/ble_device_wrapper.dart';

class BluetoothDeviceList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BluetoothDeviceListState();
}

class BluetoothDeviceListState extends State<BluetoothDeviceList> {
  Map<String, BluetoothDeviceWrapper> _devices = Map.identity();
  final _bleClient = BluetoothClient();

  @override
  void initState() {
    _bleClient.scan().listen((device) {
      _devices[device.id.id] = BluetoothDeviceWrapper(device);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _devices.values.map((BluetoothDeviceWrapper device) => ListTile(
        leading: Icon(Icons.devices_other),
        title: Text(device.device.id.id),
      )).toList()
    );
  }
}