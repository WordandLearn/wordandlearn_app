// To parse this JSON data, do
//
//     final example = exampleFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:word_and_learn/models/models.dart';

List<Example> exampleFromJson(String str) =>
    List<Example>.from(json.decode(str).map((x) => Example.fromJson(x)));

String exampleToJson(List<Example> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class Example extends ColorModel {
  @Id(assignable: true)
  final int id;
  final String originalText;
  final String transformedText;
  final String guide;
  bool completed;
  final int topic;

  Example({
    required this.id,
    required this.originalText,
    required this.transformedText,
    required this.guide,
    required this.completed,
    required this.topic,
  });

  factory Example.fromJson(Map<String, dynamic> json) => Example(
        id: json["id"],
        originalText: json["original_text"],
        transformedText: json["transformed_text"],
        guide: json["guide"],
        completed: json["completed"] ?? false,
        topic: json["topic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "original_text": originalText,
        "transformed_text": transformedText,
        "guide": guide,
        "completed": completed,
        "topic": topic,
      };
}
