import 'package:equatable/equatable.dart';

class ScheduleItem extends Equatable {
  final String title;
  final String speaker;
  final String date;
  final String time;
  final String description;
  final String hall;
  final String category;

  const ScheduleItem(
      {required this.title,
      required this.speaker,
      required this.date,
      required this.time,
      required this.description,
      required this.hall,
      required this.category});

  static ScheduleItem fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
        title: json['title'],
        speaker: json['speaker'],
        date: json['dateAsString'],
        time: json['timeAsString'],
        description: json['description'],
        hall: json['hall'],
        category: json['category']);
  }

  @override
  List<Object?> get props =>
      [title, speaker, time, description, hall, category];
}
