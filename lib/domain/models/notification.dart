import 'package:deep_conference/domain/models/schedule_items.dart';
import 'package:equatable/equatable.dart';

class UserNotification extends Equatable {
  final String id;
  final String body;
  final String title;
  final ScheduleItem scheduleItem;

  final DateTime time;

  const UserNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.scheduleItem,
  });

  @override
  List<Object?> get props => [id, body, title, time, scheduleItem];
}
