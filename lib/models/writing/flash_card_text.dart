// To parse this JSON data, do
//
//     final flashcardText = flashcardTextFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:word_and_learn/models/writing/models.dart';

List<FlashcardText> flashcardTextFromJson(String str) =>
    List<FlashcardText>.from(
        json.decode(str).map((x) => FlashcardText.fromJson(x)));

String flashcardTextToJson(List<FlashcardText> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class FlashcardText extends ColorModel {
  @Id(assignable: true)
  final int id;
  final String text;
  final int topic;
  String? title;
  bool completed;
  MiniActivity? miniActivity;

  FlashcardText(
      {required this.id,
      required this.text,
      required this.topic,
      this.title,
      this.miniActivity,
      this.completed = false});

  factory FlashcardText.fromJson(Map<String, dynamic> json) => FlashcardText(
      id: json["id"],
      text: json["text"],
      topic: json["topic"],
      title: json["title"],
      miniActivity: json["data"] != null
          ? json["data"]["mini_activity"] != null
              ? MiniActivity.fromJson(json["data"]["mini_activity"])
              : null
          : null,
      completed: json["completed"] ?? false);

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "topic": topic,
      };

  @override
  String toString() {
    return text;
  }

  Future<String?> get flashCardTitle {
    if (title == null) {
      return Future.value("");
    } else {
      return Future.value(title);
    }
  }

  void setCompleted() {
    completed = true;
  }
}
