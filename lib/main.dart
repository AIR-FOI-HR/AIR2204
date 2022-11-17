import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'data/models/schedule_items.dart';
import 'firebase_options.dart';

//na ovaj način se aplikacija povezuje na firebase
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Firestore read test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        title: Text(widget.title),
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
