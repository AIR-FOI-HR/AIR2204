part of 'saved_schedule_cubit.dart';

class SavedScheduleState extends Equatable {
  final List<ScheduleItem> scheduleItems;
  final List<ScheduleItem> savedItems;
  final bool loading;
  final dynamic error;
  final DateTime currentDate;
  final ScheduleItemCategory currentCategory;
  final List<DateTime> allDates;

  const SavedScheduleState(
      {this.scheduleItems = const [],
      this.savedItems = const [],
      this.loading = true,
      this.error,
      required this.currentDate,
      required this.allDates,
      this.currentCategory = ScheduleItemCategory.all});

  //test fixanja za initial state
  SavedScheduleState.inital(this.scheduleItems, this.savedItems, this.loading, this.error, this.currentCategory)
      : currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        allDates = [];

  @override
  List<Object?> get props => [scheduleItems, loading, error, currentDate, currentCategory, savedItems, allDates];

  SavedScheduleState copyWith(
      {ScheduleItemCategory? currentCategory,
      error,
      allDates,
      List<ScheduleItem>? savedItems,
      List<ScheduleItem>? scheduleItems,
      bool? loading,
      DateTime? currentDate}) {
    return SavedScheduleState(
        error: error ?? this.error,
        currentCategory: currentCategory ?? this.currentCategory,
        currentDate: currentDate ?? this.currentDate,
        allDates: allDates ?? this.allDates,
        savedItems: savedItems ?? this.savedItems,
        scheduleItems: scheduleItems ?? this.scheduleItems,
        loading: loading ?? this.loading);
  }
}
