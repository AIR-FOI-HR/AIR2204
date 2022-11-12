import 'package:equatable/equatable.dart';
import 'package:expandable_attempt/data/models/schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
