import 'dart:async';
import 'dart:convert';
import 'package:deep_conference/domain/models/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository {
  static final LocalStorageRepository _instance = LocalStorageRepository._privateConstructor();

  factory LocalStorageRepository() {
    return _instance;
  }

  late SharedPreferences preferences;

  LocalStorageRepository._privateConstructor() {
    SharedPreferences.getInstance().then((prefs) {
      preferences = prefs;
    });
  }

  Future<void> saveNotification(UserNotification notification, String userId) async {
    List<String>? userNotifs = preferences.getStringList(userId);
    if (userNotifs != null) {
      preferences.remove(userId);
      userNotifs.add(notification.id);
      preferences.setStringList(userId, userNotifs);
    } else {
      preferences.setStringList(userId, <String>[notification.id]);
    }
    preferences.setStringList(notification.id, <String>[
      notification.title,
      notification.body,
      jsonEncode(notification.scheduleItem.toJson()),
      notification.time.toString(),
    ]);
  }

  List<String> getStringList(String key) {
    return preferences.getStringList(key) ?? [];
  }

  void removeUser(String userId) {
    preferences.remove(userId);
  }

  Future<void> removeNotificationFromStorage(String notifId, String userId) async {
    List<String>? userNotifs = preferences.getStringList(userId);
    if (userNotifs != null) {
      userNotifs.removeWhere((element) => element == notifId);
      preferences.setStringList(userId, userNotifs);
    }
    await preferences.remove(notifId);
  }
}
