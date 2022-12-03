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
          ScheduleState(
            currentDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
          ),
        );

  final ScheduleRepository scheduleRepository;

  void readAllItems() async {
    emit(ScheduleState(currentDate: state.currentDate, currentCategory: state.currentCategory));
    try {
      final data = await scheduleRepository.getScheduleItems();

      DateTime currentDate = state.currentDate;
      final List<DateTime> allDates = groupBy(data, (scheduleItem) => scheduleItem.date).keys.toList()..sort();
      List<ScheduleItem> dataFiltered = data.where((scheduleItem) => scheduleItem.date == state.currentDate).toList();

      if (dataFiltered.isEmpty) {
        dataFiltered = data.where((scheduleItem) => scheduleItem.date == allDates.first).toList();
        currentDate = allDates.first;
      }

      emit(ScheduleState(
          allItems: data,
          scheduleItems: dataFiltered,
          loading: false,
          currentCategory: ScheduleItemCategory.all,
          currentDate: currentDate));
    } catch (e) {
      emit(ScheduleState(error: e, currentDate: state.currentDate, currentCategory: state.currentCategory));
    }
  }

  void sortByCategory(ScheduleItemCategory category) async {
    emit(ScheduleState(allItems: state.allItems, currentDate: state.currentDate, currentCategory: category));

    List<ScheduleItem> filteredItems =
        state.allItems.where((scheduleItem) => scheduleItem.date == state.currentDate).toList();

    if (category != ScheduleItemCategory.all) {
      filteredItems = filteredItems.where((scheduleItem) => scheduleItem.category == category).toList();
    }

    emit(ScheduleState(
        allItems: state.allItems,
        scheduleItems: filteredItems,
        loading: false,
        currentCategory: category,
        currentDate: state.currentDate));
  }

  void sortByDate(DateTime date) async {
    emit(ScheduleState(allItems: state.allItems, currentDate: date, currentCategory: ScheduleItemCategory.all));

    final List<ScheduleItem> filteredItems = state.allItems.where((scheduleItem) => scheduleItem.date == date).toList();

    emit(ScheduleState(
        allItems: state.allItems,
        scheduleItems: filteredItems,
        loading: false,
        currentCategory: ScheduleItemCategory.all,
        currentDate: date));
  }
}
