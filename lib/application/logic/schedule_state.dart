part of 'schedule_cubit.dart';

class ScheduleState extends Equatable {
  final List<ScheduleItem> scheduleItems;
  final bool loading;
  final dynamic error;

  const ScheduleState({this.scheduleItems = const [], this.loading = true, this.error});

  @override
  List<Object?> get props => [scheduleItems, loading, error];
}
