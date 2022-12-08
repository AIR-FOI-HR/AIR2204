part of 'schedule_cubit.dart';

class ScheduleState extends Equatable {
  final List<ScheduleItem> scheduleItems;
  final List<ScheduleItem> allItems;
  final bool loading;
  final dynamic error;
  final DateTime currentDate;
  final ScheduleItemCategory currentCategory;

  const ScheduleState(
      {this.scheduleItems = const [],
      this.allItems = const [],
      this.loading = true,
      this.error,
      required this.currentDate,
      this.currentCategory = ScheduleItemCategory.all});

  factory ScheduleState.inital() {
    return ScheduleState(
      currentDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    );
  }

  ScheduleState copyWith(
      {ScheduleItemCategory? currentCategory,
      error,
      List<ScheduleItem>? allItems,
      List<ScheduleItem>? scheduleItems,
      bool? loading,
      DateTime? currentDate}) {
    return ScheduleState(
        error: error ?? this.error,
        currentCategory: currentCategory ?? this.currentCategory,
        currentDate: currentDate ?? this.currentDate,
        allItems: allItems ?? this.allItems,
        scheduleItems: scheduleItems ?? this.scheduleItems,
        loading: loading ?? this.loading);
  }

  List<DateTime> get allDates {
    final groupByDates = groupBy(allItems, (scheduleItem) => scheduleItem.date);
    final dates = groupByDates.keys.toList()..sort();
    return dates;
  }

  @override
  List<Object?> get props => [scheduleItems, loading, error, currentDate, currentCategory, allItems];
}
