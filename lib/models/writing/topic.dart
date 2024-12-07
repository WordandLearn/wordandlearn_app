import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:word_and_learn/utils/sticker_utils.dart';

import 'color_model.dart';

// To parse this JSON data, do
//
//     final topic = topicFromJson(jsonString);

List<Topic> topicFromJson(String str) =>
    List<Topic>.from(json.decode(str).map((x) => Topic.fromJson(x)));

String topicToJson(List<Topic> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class Topic extends ColorModel {
  @Id(assignable: true)
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String description;
  bool completed;
  final String tag;
  final int lesson;
  final bool isCurrent;
  final bool isLocked;
  final String? image;
  bool exerciseCompleted;
  Excerise? excerise;

  Topic(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.title,
      required this.description,
      required this.completed,
      required this.tag,
      required this.lesson,
      this.image,
      this.exerciseCompleted = false,
      this.isLocked = false,
      this.isCurrent = false});

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
      id: json["id"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      title: json["title"],
      description: json["description"],
      completed: json["completed"],
      tag: json["tag"],
      lesson: json["lesson"],
      exerciseCompleted: json["exercise_completed"] ?? false,
      image: StickerUtils.getRandomSticker());

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "title": title,
        "description": description,
        "completed": completed,
        "tag": tag,
        "lesson": lesson,
      };
}

class Excerise {
  final bool isCompleted;

  Excerise({required this.isCompleted});
}
