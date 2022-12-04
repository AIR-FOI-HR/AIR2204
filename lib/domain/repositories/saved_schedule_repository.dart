import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_conference/constants/my_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/schedule_items.dart';

class SavedRepository {
  final FirebaseFirestore firestore;

  SavedRepository({required this.firestore});

  Future<List<ScheduleItem>> getSavedItems() async {
    final docRef = firestore.collection(MyCollections.savedItems).doc(FirebaseAuth.instance.currentUser!.uid);
    List<dynamic> idList = await docRef.get().then((snapshot) {
      return snapshot.data()!['savedItems'];
    });

    DocumentReference<Map<String, dynamic>> savedItemsQuery;
    ScheduleItem savedItem;
    List<ScheduleItem> savedItemsList = [];

    for (var id in idList) {
      savedItemsQuery = firestore.collection(MyCollections.scheduleItems).doc(id);
      savedItem = await savedItemsQuery
          .get()
          .then((value) => ScheduleItem.fromJson(value.data() as Map<String, dynamic>, value.id));
      savedItemsList.add(savedItem);
    }

    return savedItemsList;
  }

  void refreshSavedItems(List<ScheduleItem> items) async {
    List<String> itemIds = [];
    for (var element in items) {
      itemIds.add(element.id);
    }
    final docRef = firestore.collection('savedItems').doc(FirebaseAuth.instance.currentUser!.uid);
    await docRef.set({'savedItems': FieldValue.arrayUnion(itemIds)});
  }
}
