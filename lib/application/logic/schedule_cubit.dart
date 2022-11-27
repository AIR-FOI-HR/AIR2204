import 'package:deep_conference/domain/repositories/schedule_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../constants/my_dates.dart';
import '../../constants/schedule_item_categories.dart';
import '../../domain/models/schedule_items.dart';
part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit()
      : super(
          ScheduleState(
            scheduleItems: const [],
            date: MyDates.firstDay,
            //FILTRACIJA
            currentCategory: ScheduleItemCategory.all,
            currentDate: MyDates.firstDay,
          ),
        );

  final scheduleRepository = ScheduleRepository();
  //FILTRACIJA
  void readScheduleItems(ScheduleItemCategory category, DateTime date) async {
    final data = await scheduleRepository.getScheduleList(category, date);
    emit(ScheduleState(scheduleItems: data, date: date, currentCategory: category, currentDate: date));
  }
}
