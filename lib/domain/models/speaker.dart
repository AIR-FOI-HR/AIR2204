import 'package:equatable/equatable.dart';

class Speaker extends Equatable {
  final String image;
  final String info;
  final String name;
  final String title;

  const Speaker({
    required this.image,
    required this.info,
    required this.name,
    required this.title,
  });

  static Speaker fromJson(Map<String, dynamic> json) {
    return Speaker(
      image: json['image'],
      info: json['info'],
      name: json['name'],
      title: json['title'],
    );
  }

  @override
  List<Object?> get props => [
        image,
        info,
        name,
        title,
      ];
}
