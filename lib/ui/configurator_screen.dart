import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/logic/app_mode.dart';
import 'package:hack_heroes_mobile/logic/user_settings.dart';
import 'package:hack_heroes_mobile/ui/blind_home.dart';
import 'package:hack_heroes_mobile/ui/helper_home.dart';
import 'package:permission_handler/permission_handler.dart';

class ConfiguratorScreen extends StatefulWidget {
  Widget _about(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.live_help,
                  color: Colors.blue,
                  size: 100,
                ),
                Text('Hack Heroes',
                  style: Theme.of(context).textTheme.title.apply(fontSizeFactor: 2),
                )
              ],
            ),
            Text('Welcome to DA APP. It is great. It works. This is a description. You can you DA APP. Press this and that to do things.',
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => ConfiguratorScreenState();
}

class ConfiguratorScreenState extends State<ConfiguratorScreen> with TickerProviderStateMixin {
  AppMode _mode = AppMode.Helper;
  bool _demoMode = false;

  Animation<Offset> _cardAnimation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _mode = UserSettings.mode;
    _demoMode = UserSettings.demoMode;

    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this
    );
    _cardAnimation = MaterialPointArcTween(begin: Offset.zero, end: Offset(1.0, 0.0)).animate(_controller);

    _controller.value = _demoMode ? 1 : 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _checkPermissions() async {
//    return Future.delayed(Duration(seconds: 1), () => true);
    final camera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    final mic = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);

    return camera == PermissionStatus.granted && mic == PermissionStatus.granted;
  }

  Widget _getPermissions(context) {
    return FutureBuilder(
      future: _checkPermissions(),
      initialData: false,
      builder: (context, AsyncSnapshot snapshot) => AnimatedSize(
        alignment: Alignment.center,
        duration: Duration(milliseconds: 200),
        reverseDuration: Duration(milliseconds: 200),
        vsync: this,
        curve: Curves.easeInOut,
        child: FloatingActionButton.extended(
          backgroundColor: snapshot.data ? Colors.greenAccent : Colors.blueAccent,
          icon: snapshot.data ? Icon(Icons.done) : Icon(Icons.perm_camera_mic),
          label: snapshot.data ? Text('Permissions granted') : Text('Grant permissions'),
          onPressed: () async {
            await PermissionHandler().requestPermissions([
              PermissionGroup.camera, PermissionGroup.microphone,
            ]);
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _modeSelect(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, right: 32),
          child: Icon(Icons.settings,
            size: 30,
          ),
        ),
        Text('Mode',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subhead,//.apply(fontSizeFactor: 1.2),
        ),
        Expanded(
          child: RadioListTile(
            title: Text('Blind',
                style: Theme.of(context).textTheme.button
            ),
            value: AppMode.Blind,
            groupValue: _mode,
            onChanged: (mode) => setState(() => _mode = mode),
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: Text('Helper',
              style: Theme.of(context).textTheme.button,
            ),
            value: AppMode.Helper,
            groupValue: _mode,
            onChanged: (mode) => setState(() => _mode = mode),
          ),
        ),
      ],
    );
  }

  Widget _demoSelect(BuildContext context) {
    return SwitchListTile(
      title: Text('Demo mode'),
      subtitle: Text('Select to simulate a Braillepad'),
      value: _demoMode,
      secondary: Icon(Icons.developer_mode),
      onChanged: (bool value) => setState(() {
        _demoMode = value;
        _demoMode ? _controller.forward() : _controller.reverse();
      }),
    );
  }

  Widget _pairDevice(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.bluetooth_searching,
                  color: Colors.blue,
                  size: 50,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                ),
                Text('Pair your Braillepad',
                  style: Theme.of(context).textTheme.title.apply(fontSizeFactor: 1.3),
                )
              ],
            ),
            Text('Device 1'),
            Text('Device 1'),
            Text('Device 3'),
          ],
        ),
      ),
    );
  }

  Widget _settings(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Please configure the app',
              style: Theme.of(context).textTheme.title,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
            _getPermissions(context),
            _modeSelect(context),
            _demoSelect(context),
          ],
        ),
      ),
    );
  }

  Widget _finish(BuildContext context) {
    return FutureBuilder(
      future: _checkPermissions(),
      initialData: false,
      builder: (context, AsyncSnapshot snapshot) => AnimatedCrossFade(
        duration: Duration(milliseconds: 200),
        reverseDuration: Duration(milliseconds: 200),
        firstCurve: Curves.easeIn,
        secondCurve: Curves.easeOut,
        crossFadeState: snapshot.data ? CrossFadeState.showSecond : CrossFadeState.showFirst,

        firstChild: FloatingActionButton.extended(
          onPressed: null,
          heroTag: 'continueDisabled',
          label: Text('Continue'),
          icon: Icon(Icons.done),
          backgroundColor: Colors.blueAccent,
        ),
        secondChild: FloatingActionButton.extended(
          heroTag: 'continueEnabled',
          onPressed: () {
            UserSettings.mode = _mode;
            UserSettings.demoMode = _demoMode;
            UserSettings.firstRun = false;

            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                switch (_mode) {
                  case AppMode.Blind:
                    return BlindHome();

                  case AppMode.Helper:
                    return HelperHome();

                  default:
                    return BlindHome();
                }
              }
            ));
          },
          label: Text('Continue'),
          icon: Icon(Icons.done),
          backgroundColor: Colors.greenAccent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      floatingActionButton: _finish(context),
      body: ListView(
        children: <Widget>[
          widget._about(context),
          _settings(context),
          SlideTransition(
            position: _cardAnimation,
            child: _pairDevice(context),
          ),

          // write sliding animation
//          _demoMode ? Container() : _pairDevice(context),
        ],
      ),
    );
  }
}