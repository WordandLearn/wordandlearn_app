// To parse this JSON data, do
//
//     final flashcardText = flashcardTextFromJson(jsonString);

import 'dart:convert';

List<FlashcardText> flashcardTextFromJson(String str) =>
    List<FlashcardText>.from(
        json.decode(str).map((x) => FlashcardText.fromJson(x)));

String flashcardTextToJson(List<FlashcardText> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FlashcardText {
  final int id;
  final String text;
  final int topic;

  FlashcardText({
    required this.id,
    required this.text,
    required this.topic,
  });

  factory FlashcardText.fromJson(Map<String, dynamic> json) => FlashcardText(
        id: json["id"],
        text: json["text"],
        topic: json["topic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "topic": topic,
      };

  @override
  String toString() {
    return text;
  }
}
