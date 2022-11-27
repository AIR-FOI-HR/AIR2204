import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_conference/application/presentation/speaker_screen.dart';
import 'package:deep_conference/domain/models/schedule_items.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import '../../domain/models/speaker.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.scheduleItem});
  final ScheduleItem scheduleItem;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<Speaker> getSpeaker() {
    return FirebaseFirestore.instance
        .collection('speakers')
        .doc(widget.scheduleItem.speakerId)
        .get()
        .then((value) => Speaker.fromJson(value.data()!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule Item Detail',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 5, 30, 5),
        child: Column(
          children: [
            FutureBuilder<Speaker>(
              future: getSpeaker(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final Speaker speaker = snapshot.data!;
                  return RichText(
                    text: TextSpan(
                      text: "Speaker: ${speaker.name}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: MyColors.color772DFF),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpeakerScreen(
                                speaker: speaker,
                              ),
                            ),
                          );
                        },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(widget.scheduleItem.description, style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
