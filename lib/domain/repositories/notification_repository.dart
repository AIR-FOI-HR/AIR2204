import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/notification.dart';

class NotificationRepository {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  NotificationRepository();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings initializationSettingsDarwin = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(UserNotification notification, DateTime time) async {
    final tz.TZDateTime notifTime = tz.TZDateTime.from(time, tz.local).subtract(const Duration(minutes: 60));
    if (notifTime.isAfter(tz.TZDateTime.now(tz.local))) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notification.id.hashCode,
          notification.title,
          notification.body,
          notifTime,
          //  tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
          const NotificationDetails(
            android: AndroidNotificationDetails('main_channel', 'Main Channel',
                importance: Importance.max, priority: Priority.max, icon: '@mipmap/ic_launcher'),
            iOS: DarwinNotificationDetails(
              sound: 'default.wav',
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);
    }
  }

  Future<void> removeNotification(String id) async {
    await flutterLocalNotificationsPlugin.cancel(id.hashCode);
  }
}
