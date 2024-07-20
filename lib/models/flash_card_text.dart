// To parse this JSON data, do
//
//     final flashcardText = flashcardTextFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:word_and_learn/models/models.dart';

List<FlashcardText> flashcardTextFromJson(String str) =>
    List<FlashcardText>.from(
        json.decode(str).map((x) => FlashcardText.fromJson(x)));

String flashcardTextToJson(List<FlashcardText> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FlashcardText extends ColorModel {
  final int id;
  final String text;
  final int topic;
  String? title;
  bool completed;

  FlashcardText(
      {required this.id,
      required this.text,
      required this.topic,
      this.title,
      this.completed = false});

  factory FlashcardText.fromJson(Map<String, dynamic> json) => FlashcardText(
      id: json["id"],
      text: json["text"],
      topic: json["topic"],
      title: json["title"],
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
      Gemini gemini = Gemini.instance;
      return gemini
          .text(
              "Generate a title for a flashcard with the following text: $text")
          .then((value) {
        title = value?.content?.parts?.map((e) => e.text).first;
        return title;
      });
    } else {
      return Future.value(title);
    }
  }

  void setCompleted() {
    //TODO: Update Database
    completed = true;
  }
}
