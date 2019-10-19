import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
  FirebaseNotifications();

  Future<void> init() async {
    _fcm.configure(
      onMessage: _onForegroundMessage,
      onResume: _onNotificationClick,
      onLaunch: _onNotificationClick,
    );
    print(await _fcm.getToken());
    await _fcm.subscribeToTopic('helpNeeded');
  }

  Future<void> dispose() async {

  }

  Future<void> _onForegroundMessage(Map<String, dynamic> message) async {
    print(message);
  }

  Future<void> _onNotificationClick(Map<String, dynamic> message) async {
    print(message);
  }

  final FirebaseMessaging _fcm = FirebaseMessaging();
}