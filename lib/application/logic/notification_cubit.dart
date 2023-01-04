import 'package:deep_conference/domain/repositories/local_storage_repository.dart';
import 'package:deep_conference/domain/repositories/notification_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

import '../../domain/models/notification.dart';
import '../../domain/models/schedule_items.dart';
import '../../domain/repositories/authentication_repository.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final AuthenticationRepository authenticationRepository;
  final NotificationRepository notificationRepository;
  final LocalStorageRepository localStorageRepository;
  NotificationCubit(this.authenticationRepository, this.notificationRepository, this.localStorageRepository)
      : super(const NotificationState());

  String _createNotifId(String userId, String itemId) {
    return userId + itemId;
  }

  Future<void> createNotification(ScheduleItem item) async {
    final String userId = authenticationRepository.getUserId();
    final String id = _createNotifId(userId, item.id);

    final UserNotification notification = UserNotification(
        id: id,
        title: item.title,
        body: item.hall,
        scheduleItem: item,
        time: item.startTime.subtract(const Duration(minutes: 60)));

    if (notification.time.isAfter(DateTime.now())) {
      await notificationRepository.showNotification(notification, item.startTime);
      await localStorageRepository.saveNotification(notification, userId);
    }
  }

  Future<void> removeNotification({String? notifId, String? itemId}) async {
    final String userId = authenticationRepository.getUserId();
    if (notifId == null && itemId != null) {
      notifId = _createNotifId(userId, itemId);
    }

    await notificationRepository.removeNotification(notifId!);
    await localStorageRepository.removeNotificationFromStorage(notifId, userId);

    readUserNotifications();
  }

  void readUserNotifications() {
    final List<UserNotification> notificationList = [];
    final String userId = authenticationRepository.getUserId();

    final List<String> userNotifIds = localStorageRepository.getStringList(userId);

    if (userNotifIds.isNotEmpty) {
      for (var notifId in userNotifIds) {
        List<String>? prefNotification = localStorageRepository.getStringList(notifId);

        final UserNotification notification = UserNotification(
          id: notifId,
          title: prefNotification[0],
          body: prefNotification[1],
          time: DateTime.parse(prefNotification[3]),
          scheduleItem: ScheduleItem.fromNotifJson(jsonDecode(prefNotification[2])),
        );
        if (notification.time.isBefore(DateTime.now())) {
          notificationList.add(notification);
        }
      }
    }
    emit(NotificationState(notificationList: notificationList.reversed.toList()));
  }
}
