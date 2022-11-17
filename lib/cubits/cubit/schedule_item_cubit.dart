import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/schedule_items.dart';
part 'schedule_item_state.dart';

class ScheduleItemCubit extends Cubit<ScheduleItemState> {
  ScheduleItemCubit() : super(const ScheduleItemState(scheduleItems: []));

  Future<void> listenToScheduleItems() async {
    if (readScheduleItems() != null) {
      await readScheduleItems();
    }
  }

  readScheduleItems() {
    // ignore: unused_local_variable
    final scheduleItemList = FirebaseFirestore.instance
        .collection('scheduleItems')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScheduleItem.fromJson(doc.data()))
            .toList());
    //emit(ScheduleItemState(scheduleItems: scheduleItemList));
  }
}
