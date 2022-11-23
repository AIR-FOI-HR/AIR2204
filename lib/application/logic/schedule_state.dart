part of 'schedule_cubit.dart';

class ScheduleState extends Equatable {
  final List<ScheduleItem> scheduleItems;

  const ScheduleState({required this.scheduleItems});

  @override
  List<Object> get props => [scheduleItems];
}
