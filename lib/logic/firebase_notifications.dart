import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hack_heroes_mobile/logic/app_mode.dart';
import 'package:hack_heroes_mobile/logic/user_settings.dart';

class FirebaseNotifications {

  static Future<void> init() async {
    _fcm.configure(
      onMessage: _onForegroundMessage,
      onResume: _onNotificationClick,
      onLaunch: _onNotificationClick,
    );
    if (UserSettings.mode == AppMode.Helper) {
      await _fcm.subscribeToTopic('helpNeeded');
    }
    else {
      await _fcm.unsubscribeFromTopic('helpNeeded');
    }
  }

  static Future<void> dispose() async {
    _onResponse = null;
    _onHelpNeeded = null;
  }

  static void onResponse(Function cb) {
    _onResponse = cb;
  }

  static void onHelpNeeded(Function cb) {
    _onHelpNeeded = cb;
  }

  static Future<String> getToken() async {
    return await _fcm.getToken();
  }

  static Future<void> _onForegroundMessage(Map<String, dynamic> message) async {
    print(message);
    if (_onResponse != null && message['notification']['title'] == 'Help received') {
      try {
        _onResponse(message['notification']['body'] as String);
      }
      catch (e) {
        print('FCM response error $e $message');
      }
    }

    if (_onHelpNeeded != null && message['notification']['title'] == 'Someone needs help') {
      try {
        _onHelpNeeded();
      }
      catch (e) {
        print('FCM response error $e $message');
      }
    }
  }

  static Future<void> _onNotificationClick(Map<String, dynamic> message) async {
    print(message);
    if (_onHelpNeeded != null && message['notification']['title'] == 'Someone needs help') {
      try {
        _onHelpNeeded();
      }
      catch (e) {
        print('FCM response error $e $message');
      }
    }
  }

  static final FirebaseMessaging _fcm = FirebaseMessaging();
  static Function _onResponse;
  static Function _onHelpNeeded;
}