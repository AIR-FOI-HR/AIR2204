import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/schedule_item_model.dart';

part 'saved_state.dart';

class SavedCubit extends Cubit<SavedState> {
  SavedCubit() : super(SavedState(savedItems: []));
  final List<Schedule> savedItems = [];

  void saveToSchedule(item) {
    savedItems.add(item);
    emit(SavedState(savedItems: savedItems));
  }

  void removeFromSchedule(item) {
    savedItems.remove(item);
    emit(SavedState(savedItems: savedItems));
  }
}
