part of 'saved_schedule_cubit.dart';

// ignore: must_be_immutable
class SavedScheduleState extends Equatable {
  final List<ScheduleItem> scheduleItems;
  final List<ScheduleItem> savedItems;
  final bool loading;
  final dynamic error;
  final DateTime currentDate;
  final ScheduleItemCategory currentCategory;
  List<DateTime> allDates;

  SavedScheduleState(
      {this.scheduleItems = const [],
      this.savedItems = const [],
      this.loading = true,
      this.error,
      required this.currentDate,
      required this.allDates,
      this.currentCategory = ScheduleItemCategory.all});

  @override
  List<Object?> get props => [scheduleItems, loading, error, currentDate, currentCategory, savedItems, allDates];
}
