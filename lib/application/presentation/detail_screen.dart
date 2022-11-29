import 'package:deep_conference/domain/models/schedule_items.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.scheduleItem});
  final ScheduleItem scheduleItem;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule Item Detail',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Text(widget.scheduleItem.description, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
