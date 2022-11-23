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
    return Text(widget.scheduleItem.title);
  }
}
