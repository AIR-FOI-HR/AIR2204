import 'package:flutter/material.dart';

import '../../domain/models/speaker.dart';

class SpeakerScreen extends StatefulWidget {
  const SpeakerScreen({super.key, required this.speaker});
  final Speaker speaker;

  @override
  State<SpeakerScreen> createState() => _SpeakerScreenState();
}

class _SpeakerScreenState extends State<SpeakerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Speaker info',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 5, 30, 5),
        child: Column(
          children: [
            Text(
              "${widget.speaker.name} : ${widget.speaker.title}",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(widget.speaker.info, style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
