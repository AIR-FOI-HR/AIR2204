import 'package:deep_conference/constants/schedule_item_categories.dart';
import 'package:deep_conference/domain/repositories/schedule_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/models/schedule_items.dart';
import '../../constants/my_dates.dart';
part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit(this.scheduleRepository)
      : super(ScheduleState(
          currentDate: MyDates.firstDay,
        ));

  final ScheduleRepository scheduleRepository;

  void readScheduleItems(ScheduleItemCategory category, DateTime date) async {
    emit(ScheduleState(
      currentCategory: category,
      currentDate: date,
    ));
    try {
      final data = await scheduleRepository.getScheduleList(category, date);
      emit(ScheduleState(scheduleItems: data, loading: false, currentCategory: category, currentDate: date));
    } catch (e) {
      emit(ScheduleState(error: e, currentCategory: category, currentDate: date));
    }
  }
}
