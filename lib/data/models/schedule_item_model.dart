import 'package:expandable_attempt/constants/schedule_item_category_model.dart';
import 'package:equatable/equatable.dart';

class ScheduleItem extends Equatable {
  final String id;
  final String title;
  final String speaker;
  final String date;
  final String time;
  final String description;
  final String hall;
  final ScheduleItemCategory category;

  const ScheduleItem(
      {required this.id,
      required this.title,
      required this.speaker,
      required this.date,
      required this.time,
      required this.description,
      required this.hall,
      required this.category});

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, speaker, time, description, hall, category];
}
