import 'package:equatable/equatable.dart';
import '../../constants/schedule_item_categories.dart';

// ignore: must_be_immutable
class ScheduleItem extends Equatable {
  String id;
  final String title;
  final String speaker;
  final DateTime startTime;
  final DateTime endTime;
  final String speakerId;
  final String description;
  final String hall;
  final ScheduleItemCategory category;

  ScheduleItem(
      {this.id = "",
      required this.title,
      required this.speaker,
      required this.startTime,
      required this.endTime,
      required this.speakerId,
      required this.description,
      required this.hall,
      required this.category});

  static ScheduleItem fromJson(Map<String, dynamic> json, String id) {
    return ScheduleItem(
      id: id,
      title: json['title'],
      speaker: json['speaker'],
      startTime: json['startTime'].toDate(),
      endTime: json['endTime'].toDate(),
      speakerId: json['speakerId'],
      description: json['description'],
      hall: json['hall'],
      category: ScheduleItemCategoryX.fromString(json['category']),
    );
  }

  DateTime get date {
    DateTime date = DateTime(startTime.year, startTime.month, startTime.day);
    return date;
  }

  @override
  List<Object?> get props => [id, title, speaker, description, hall, category, speakerId];
}
