import 'package:deep_conference/constants/schedule_item_categories.dart';
import 'package:deep_conference/domain/repositories/schedule_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/models/schedule_items.dart';
import 'package:collection/collection.dart';
part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit(this.scheduleRepository)
      : super(
          ScheduleState.inital(),
        );

  final ScheduleRepository scheduleRepository;

  void readAllItems() async {
    emit(ScheduleState.inital());
    try {
      final data = await scheduleRepository.getScheduleItems();

      DateTime currentDate = state.currentDate;
      final List<DateTime> allDates = groupBy(data, (scheduleItem) => scheduleItem.date).keys.toList()..sort();
      List<ScheduleItem> dataFiltered = data.where((scheduleItem) => scheduleItem.date == state.currentDate).toList();

      if (dataFiltered.isEmpty) {
        dataFiltered = data.where((scheduleItem) => scheduleItem.date == allDates.first).toList();
        currentDate = allDates.first;
      }
      emit(state.copyWith(allItems: data, scheduleItems: dataFiltered, loading: false, currentDate: currentDate));
    } catch (e) {
      emit(state.copyWith(error: e));
    }
  }

  void sortByCategory(ScheduleItemCategory category) async {
    emit(state.copyWith(currentCategory: category, loading: true));
    List<ScheduleItem> filteredItems =
        state.allItems.where((scheduleItem) => scheduleItem.date == state.currentDate).toList();
    if (category != ScheduleItemCategory.all) {
      filteredItems = filteredItems.where((scheduleItem) => scheduleItem.category == category).toList();
    }
    emit(state.copyWith(scheduleItems: filteredItems, loading: false));
  }

  void sortByDate(DateTime date) async {
    emit(state.copyWith(currentCategory: ScheduleItemCategory.all, currentDate: date, loading: true));
    final List<ScheduleItem> filteredItems = state.allItems.where((scheduleItem) => scheduleItem.date == date).toList();
    emit(state.copyWith(scheduleItems: filteredItems, loading: false));
  }
}
