// To parse this JSON data, do
//
//     final lesson = lessonFromJson(jsonString);

import 'dart:convert';

import 'package:word_and_learn/models/models.dart';

List<Lesson> lessonFromJson(String str) =>
    List<Lesson>.from(json.decode(str).map((x) => Lesson.fromJson(x)));

String lessonToJson(List<Lesson> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Lesson extends BaseModel {
  final String title;
  final String description;
  final DateTime createdAt;
  final int id;
  final String? image;
  final bool isCompleted;

  Lesson(
      {required this.title,
      required this.description,
      required this.createdAt,
      required this.id,
      this.image,
      this.isCompleted = false});

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
      title: json["title"],
      description: json["description"],
      createdAt: DateTime.parse(json["created_at"]),
      id: json["id"],
      isCompleted: json["completed"] ?? false,
      image: json["image"]);

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
