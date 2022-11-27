import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/schedule_item_categories.dart';
import '../models/schedule_items.dart';

class ScheduleRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<ScheduleItem>> getScheduleList(ScheduleItemCategory category, DateTime date) async {
    QuerySnapshot scheduleListData;

    //FILTRACIJA
    DateTime start = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime end = DateTime(date.year, date.month, date.day, 23, 59, 59);

    if (category == ScheduleItemCategory.all) {
      scheduleListData = await _firestore
          .collection('scheduleItems')
          .where('startTime', isGreaterThanOrEqualTo: start)
          .where('startTime', isLessThanOrEqualTo: end)
          .orderBy('startTime', descending: false)
          .get();
    } else {
      scheduleListData = await _firestore
          .collection('scheduleItems')
          .where('startTime', isGreaterThanOrEqualTo: start)
          .where('startTime', isLessThanOrEqualTo: end)
          .where('category', isEqualTo: category.name)
          .orderBy('startTime')
          .get();
    }
    List<ScheduleItem> scheduleList =
        scheduleListData.docs.map((e) => ScheduleItem.fromJson(e.data() as Map<String, dynamic>)).toList();

    return scheduleList;
  }
}
