// To parse this JSON data, do
//
//     final lesson = lessonFromJson(jsonString);

import 'dart:convert';

import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/utils/sticker_utils.dart';

List<Lesson> lessonFromJson(String str) =>
    List<Lesson>.from(json.decode(str).map((x) => Lesson.fromJson(x)));

String lessonToJson(List<Lesson> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Lesson extends ColorModel {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String? image;
  bool isCompleted;
  final LessonProgress? progress;
  final bool unlocked;
  final int session;
  final int number;

  Lesson(
      {required this.title,
      required this.description,
      required this.createdAt,
      required this.id,
      this.image,
      required this.session,
      this.progress,
      this.number = 0,
      this.unlocked = true,
      this.isCompleted = false});

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
      title: json["title"],
      description: json["description"],
      createdAt: DateTime.parse(json["created_at"]),
      id: json["id"],
      isCompleted: json["completed"] ?? false,
      number: json["number"] ?? 0,
      progress: json["progress"] != null
          ? LessonProgress.fromJson(json['progress'])
          : null,
      unlocked: json["unlocked"] ?? true,
      session: json["session"],
      image: StickerUtils.getRandomSticker());

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
