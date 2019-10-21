import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hack_heroes_mobile/bluetooth/ble_client.dart';
import 'package:hack_heroes_mobile/logic/user_settings.dart';

class BluetoothDeviceList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BluetoothDeviceListState();
}

class BluetoothDeviceListState extends State<BluetoothDeviceList> with SingleTickerProviderStateMixin {
  List<BluetoothDevice> _devices = List();
  BluetoothClient _bleClient;
  StreamSubscription _scanSub;

  @override
  void initState() {
    _bleClient = BluetoothClient();
    Future.delayed(Duration(milliseconds: 1000), () {
      _scan();
    });

    super.initState();
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    _bleClient?.dispose();
    super.dispose();
  }

  void _scan() {
    if (_bleClient.isScanning) {
      return;
    }
    _scanSub = _bleClient.scan().listen((device) {
      if (!_devices.contains(device)) {
        if (!mounted)
          return;
        setState(() {
          _devices.add(device);
        });
      }
    });
  }

  Widget _scanButton(context) {
    return IconButton(
      icon: Icon(Icons.refresh),
      onPressed: _scan,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.bluetooth_searching,
                  color: Colors.blue,
                  size: 50,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                ),
                Text('Pair your Braillepad',
                  style: Theme.of(context).textTheme.title.apply(fontSizeFactor: 1.3),
                ),
                Expanded(
                  child: Container(),
                ),
                _scanButton(context),
              ],
            ),
            AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 300),
              alignment: Alignment.topCenter,
              curve: Curves.easeInOut,
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: _devices.length,
                itemBuilder: (context, i) => ListTile(
                  leading: Icon(Icons.devices),
                  title: Text(_devices[i].name.isEmpty ? 'Unknown' : _devices[i].name),
                  subtitle: Text(_devices[i].id.id),
                  dense: true,
                  trailing: _devices[i].id.id == UserSettings.keyboardID ? Icon(Icons.done) : null,
                  onTap: () => setState(() => UserSettings.keyboardID = _devices[i].id.id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}