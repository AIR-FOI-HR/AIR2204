import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_conference/constants/my_collections.dart';

import '../models/schedule_items.dart';

class ScheduleRepository {
  final FirebaseFirestore firestore;

  const ScheduleRepository({required this.firestore});

  Future<List<ScheduleItem>> getScheduleItems() async {
    QuerySnapshot scheduleListData = await firestore.collection(MyCollections.scheduleItems).orderBy('startTime').get();
    List<ScheduleItem> scheduleList =
        scheduleListData.docs.map((e) => ScheduleItem.fromJson(e.data() as Map<String, dynamic>)).toList();

    return scheduleList;
  }
}
