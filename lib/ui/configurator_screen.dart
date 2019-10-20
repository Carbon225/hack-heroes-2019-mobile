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
                const Icon(Icons.live_help,
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

  Animation<double> _scaleAnimation;
  AnimationController _scaleController;

  Animation<Color> _finishColorAnimation;
  AnimationController _finishColorController;

  @override
  void initState() {
    _mode = UserSettings.mode;
    _demoMode = UserSettings.demoMode;

    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
      value: _demoMode ? 1 : 0,
    );
    _cardAnimation = MaterialPointArcTween(begin: Offset.zero, end: Offset(1.0, 0.0)).animate(_controller);

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
      value: 1.0,
    );

    _scaleAnimation = Tween<double>(begin: 40.0, end: 0.0)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(_scaleController);

    _finishColorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _finishColorAnimation = ColorTween(begin: Colors.blueAccent, end: Colors.greenAccent).animate(_finishColorController);


    super.initState();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _checkPermissions() async {
//    return Future.delayed(Duration(seconds: 1), () => false);
    final camera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    return camera == PermissionStatus.granted;
  }

  Widget _getPermissions(context) {
    return FutureBuilder(
      future: _checkPermissions(),
      initialData: true,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data) {
          _scaleController.forward();
        }
        else {
          _scaleController.reverse();
        }
        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return ConstrainedBox(
              constraints: BoxConstraints.loose(Size.fromHeight(_scaleAnimation.value)),
              child: child,
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                onPressed: () async {
                  await PermissionHandler().requestPermissions([
                    PermissionGroup.camera,
                  ]);
                  if (await _checkPermissions()) {
                    _scaleController.forward();
                  }
                  // refresh continue button
                  setState(() {});
                },
                elevation: 10,
                color: Colors.blueAccent,
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.perm_camera_mic),
                    const Text('Grant permissions'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _modeSelect(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, right: 32),
          child: const Icon(Icons.settings,
            size: 30,
          ),
        ),
        Text('Mode',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subhead,//.apply(fontSizeFactor: 1.2),
        ),
        Expanded(
          child: Container(),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              RadioListTile(
                title: Text('Blind',
                    style: Theme.of(context).textTheme.button
                ),
                value: AppMode.Blind,
                groupValue: _mode,
                onChanged: (mode) => setState(() => _mode = mode),
              ),
              RadioListTile(
                title: Text('Helper',
                  style: Theme.of(context).textTheme.button,
                ),
                value: AppMode.Helper,
                groupValue: _mode,
                onChanged: (mode) => setState(() => _mode = mode),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _demoSelect(BuildContext context) {
    return SwitchListTile(
      title: const Text('Demo mode'),
      subtitle: const Text('Select to simulate a Braillepad'),
      value: _demoMode,
      secondary: const Icon(Icons.developer_mode),
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
                const Icon(Icons.bluetooth_searching,
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
            const Text('Device 1'),
            const Text('Device 1'),
            const Text('Device 3'),
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
            const Divider(
              height: 20,
            ),
            _getPermissions(context),
            _modeSelect(context),
            const Divider(
              height: 5,
            ),
            _demoSelect(context),
          ],
        ),
      ),
    );
  }

  Future<bool> _canContinue() async {
    if (_mode == AppMode.Helper) {
      return true;
    }
    // Blind mode
    if (_demoMode && await _checkPermissions()) {
      return true;
    }
    return false;
  }

  Widget _finish(BuildContext context) {
    return FutureBuilder(
      future: _canContinue(),
      initialData: false,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data) {
          _finishColorController.forward();
        }
        else {
          _finishColorController.reverse();
        }
        return AnimatedBuilder(
          animation: _finishColorAnimation,
          builder: (context, child) => FloatingActionButton.extended(
            onPressed: !snapshot.data ? null : () {
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
            label: const Text('Continue'),
            icon: const Icon(Icons.done),
            backgroundColor: _finishColorAnimation.value,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
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