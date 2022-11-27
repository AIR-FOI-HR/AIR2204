part of 'schedule_cubit.dart';

class ScheduleState extends Equatable {
  final List<ScheduleItem> scheduleItems;
  final DateTime date;
  //FILTRACIJA
  final DateTime currentDate;
  final ScheduleItemCategory currentCategory;

  const ScheduleState(
      //FILTRACIJA
      {required this.scheduleItems,
      required this.date,
      required this.currentCategory,
      required this.currentDate});

  @override
  //FILTRACIJA
  List<Object> get props => [scheduleItems, date, currentCategory, currentDate];
}
