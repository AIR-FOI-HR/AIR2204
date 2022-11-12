import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/schedule_item_model.dart';
part 'saved_state.dart';

class SavedCubit extends Cubit<SavedState> {
  SavedCubit() : super(const SavedState(savedItems: []));

  void saveToSchedule(item) {
    final newList = List.of(state.savedItems);
    newList.add(item);
    emit(SavedState(savedItems: newList));
  }

  void removeFromSchedule(item) {
    final newList = List.of(state.savedItems);
    newList.remove(item);
    emit(SavedState(savedItems: newList));
  }
}
