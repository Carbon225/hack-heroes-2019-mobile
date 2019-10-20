import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {

  static Future<void> init() async {
    _fcm.configure(
      onMessage: _onForegroundMessage,
      onResume: _onNotificationClick,
      onLaunch: _onNotificationClick,
    );
    await _fcm.subscribeToTopic('helpNeeded');
  }

  static Future<void> dispose() async {
    _onResponse = null;
  }

  static void onResponse(Function cb) {
    _onResponse = cb;
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
  }

  static Future<void> _onNotificationClick(Map<String, dynamic> message) async {
    print(message);
  }

  static final FirebaseMessaging _fcm = FirebaseMessaging();
  static Function _onResponse;
}