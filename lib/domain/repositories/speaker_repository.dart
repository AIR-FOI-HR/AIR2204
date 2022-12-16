import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_conference/constants/my_collections.dart';
import '../models/speaker.dart';

class SpeakerRepository {
  final FirebaseFirestore firestore;

  const SpeakerRepository({required this.firestore});

  Future<List<Speaker>> getSpeakerList(List speakerIds) async {
    List<Speaker> speakerList = [];
    if (speakerIds.isNotEmpty) {
      QuerySnapshot speakerListData = await firestore
          .collection(MyCollections.speakers)
          .where(FieldPath.documentId, whereIn: speakerIds)
          .get();

      speakerList = speakerListData.docs
          .map((e) => Speaker.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    }

    return speakerList;
  }
}
