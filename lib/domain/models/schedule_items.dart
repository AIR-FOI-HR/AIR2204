import 'package:equatable/equatable.dart';
import '../../constants/schedule_item_categories.dart';

class ScheduleItem extends Equatable {
  final String title;
  final String speaker;
  final String date;

  final String time;
  //final DateTime startTime;
  //final DateTime endTime;
  final String speakerId;

  final String description;
  final String hall;
  final ScheduleItemCategory category;

  const ScheduleItem(
      {required this.title,
      required this.speaker,
      required this.date,
      required this.time,
      required this.speakerId,
      required this.description,
      required this.hall,
      required this.category});

  static ScheduleItem fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      title: json['title'],
      speaker: json['speaker'],
      date: json['dateAsString'],
      time: json['timeAsString'],

      //startTime: json['startTime'],
      //endTime: json['endTime'],
      speakerId: json['speakerId'],

      description: json['description'],
      hall: json['hall'],
      category: ScheduleItemCategoryX.fromString(json['category']),
    );
  }

  @override
  List<Object?> get props =>
      [title, speaker, time, description, hall, category, speakerId];
}
