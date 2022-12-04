import 'package:collection/collection.dart';
import 'package:deep_conference/domain/repositories/saved_schedule_repository.dart';
import 'package:deep_conference/domain/repositories/schedule_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/schedule_item_categories.dart';
import '../../domain/models/schedule_items.dart';

part 'saved_schedule_state.dart';

class SavedScheduleCubit extends Cubit<SavedScheduleState> {
  SavedScheduleCubit(this.savedRepository, this.scheduleRepository)
      : super(
          SavedScheduleState(
              currentDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), allDates: const []),
        );

  final ScheduleRepository scheduleRepository;
  final SavedRepository savedRepository;

  void readAllSavedItems() async {
    emit(SavedScheduleState(
        currentDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        allDates: const [],
        currentCategory: ScheduleItemCategory.all));
    try {
      final allItems = await scheduleRepository.getScheduleItems();
      final List<DateTime> allDates = groupBy(allItems, (scheduleItem) => scheduleItem.date).keys.toList()..sort();

      final List<ScheduleItem> data = await savedRepository.getSavedItems();
      data.sortBy((scheduleItem) => scheduleItem.startTime);

      DateTime currentDate = state.currentDate;
      List<ScheduleItem> dataFiltered = data.where((scheduleItem) => scheduleItem.date == state.currentDate).toList();

      if (dataFiltered.isEmpty) {
        dataFiltered = data.where((scheduleItem) => scheduleItem.date == allDates.first).toList();
        currentDate = allDates.first;
      }

      emit(SavedScheduleState(
          allDates: allDates,
          savedItems: data,
          scheduleItems: dataFiltered,
          loading: false,
          currentCategory: ScheduleItemCategory.all,
          currentDate: currentDate));
    } catch (e) {
      emit(SavedScheduleState(
          error: e, currentDate: state.currentDate, currentCategory: state.currentCategory, allDates: const []));
    }
  }

  void sortByCategory(ScheduleItemCategory category) async {
    emit(SavedScheduleState(
        savedItems: state.savedItems,
        currentDate: state.currentDate,
        currentCategory: category,
        allDates: state.allDates));

    List<ScheduleItem> filteredItems =
        state.savedItems.where((scheduleItem) => scheduleItem.date == state.currentDate).toList();

    if (category != ScheduleItemCategory.all) {
      filteredItems = filteredItems.where((scheduleItem) => scheduleItem.category == category).toList();
    }

    emit(SavedScheduleState(
        savedItems: state.savedItems,
        scheduleItems: filteredItems,
        loading: false,
        currentCategory: category,
        currentDate: state.currentDate,
        allDates: state.allDates));
  }

  void sortByDate(DateTime date) async {
    emit(SavedScheduleState(
        savedItems: state.savedItems,
        currentDate: date,
        currentCategory: ScheduleItemCategory.all,
        allDates: state.allDates));

    final List<ScheduleItem> filteredItems =
        state.savedItems.where((scheduleItem) => scheduleItem.date == date).toList();

    emit(SavedScheduleState(
        allDates: state.allDates,
        savedItems: state.savedItems,
        scheduleItems: filteredItems,
        loading: false,
        currentCategory: ScheduleItemCategory.all,
        currentDate: date));
  }

  void updatePersonalSchedule(ScheduleItem scheduleItem, bool add) {
    final savedItems = state.savedItems;

    add ? savedItems.add(scheduleItem) : savedItems.remove(scheduleItem);

    sortByCategory(state.currentCategory);
    savedRepository.refreshSavedItems(savedItems);
  }
}
