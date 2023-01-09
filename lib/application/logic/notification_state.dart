part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  final List<UserNotification> notificationList;

  const NotificationState({
    this.notificationList = const [],
  });

  @override
  List<Object?> get props => [notificationList];
}
