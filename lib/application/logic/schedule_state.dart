part of 'schedule_cubit.dart';

class ScheduleState extends Equatable {
  final List<ScheduleItem> scheduleItems;
  final bool loading;
  final dynamic error;

  final DateTime currentDate;
  final ScheduleItemCategory currentCategory;

  const ScheduleState(
      {this.scheduleItems = const [],
      this.loading = true,
      this.error,
      required this.currentDate,
      this.currentCategory = ScheduleItemCategory.all});

  @override
  List<Object?> get props => [scheduleItems, loading, error, currentDate, currentCategory];
}
