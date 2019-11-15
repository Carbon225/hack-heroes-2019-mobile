import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hack_heroes_mobile/logic/app_mode.dart';
import 'package:hack_heroes_mobile/logic/user_settings.dart';
import 'package:hack_heroes_mobile/ui/ble_device_list.dart';
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
                DecoratedBox(
                  decoration: const ShapeDecoration(
                    color: const Color(0xff4287f5),
                    shape: const RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(const Radius.circular(30)),
                    ),
                  ),
                  child: Image.asset('assets/icon/glasses.png',
                    width: 100,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Helpnet',
                      style: Theme.of(context).textTheme.title.apply(fontSizeFactor: 2),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Text('Welcome to Helpnet. Below you can choose to be a volunteer or get help from people all over the world to assist you in your daily life. If you have a Braillepad please grant all required permissions and pair your device. Otherwise, to test the app, please enable Demo Mode.',
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
    final mic = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);
    final ble = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);

    return camera == PermissionStatus.granted && mic == PermissionStatus.granted && (ble == PermissionStatus.granted || ble == PermissionStatus.disabled);
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
                    PermissionGroup.microphone,
                    PermissionGroup.location,
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

  Widget _settings(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
    if ((_demoMode || UserSettings.keyboardID.isNotEmpty) && await _checkPermissions()) {
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
        shrinkWrap: true,
        children: <Widget>[
          widget._about(context),
          _settings(context),
          FutureBuilder(
            initialData: false,
            future: Future(() async => await _checkPermissions() && _mode == AppMode.Blind && !_demoMode),
            builder: (context, AsyncSnapshot<bool> snap) {
              if (!snap.data) {
                _controller.forward();
              }
              else {
                _controller.reverse();
              }
              return SlideTransition(
                position: _cardAnimation,
                child: FutureBuilder(
                  initialData: false,
                  future: _checkPermissions(),
                  builder: (context, AsyncSnapshot<bool> snap) {
                    if (snap.data) {
                      return BluetoothDeviceList();
                    }
                    else {
                      return Container();
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}