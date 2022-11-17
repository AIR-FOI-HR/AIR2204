part of 'schedule_item_cubit.dart';

class ScheduleItemState extends Equatable {
  final List<ScheduleItem> scheduleItems;

  const ScheduleItemState({required this.scheduleItems});

  @override
  List<Object> get props => [scheduleItems];
}
