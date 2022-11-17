import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'data/models/schedule_items.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  //stream koji uzima sve podatke iz kolekcije 'scheduleItems'
  //podatke pretvara u objekte tipa ScheduleItem koristeći fromJson funkciju
  //vraća listu ScheduleItema
  Stream<List<ScheduleItem>> readScheduleItems() {
    return FirebaseFirestore.instance
        .collection('scheduleItems')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScheduleItem.fromJson(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule list'),
      ),
      //uzima se lista ScheduleItema iz readScheduleItems streama
      //za svaki scheduleItem se radi jedan tile u listi
      body: StreamBuilder<List<ScheduleItem>>(
        stream: readScheduleItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return listBuild(snapshot.data![index]);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget listBuild(ScheduleItem scheduleItem) {
    return ExpansionTile(
      title: Text(scheduleItem.title),
      subtitle: Text(scheduleItem.time),
    );
  }
}