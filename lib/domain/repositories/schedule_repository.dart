import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/schedule_items.dart';

class ScheduleRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<ScheduleItem>> getScheduleList() async {
    QuerySnapshot scheduleListData =
        await _firestore.collection('scheduleItems').get();

    List<ScheduleItem> scheduleList = scheduleListData.docs
        .map((e) => ScheduleItem.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    return scheduleList;
  }
}
