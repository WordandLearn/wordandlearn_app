// To parse this JSON data, do
//
//     final topicExample = topicExampleFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

List<TopicExample> topicExampleFromJson(String str) =>
    List<TopicExample>.from(json
        .decode(utf8.decode(str.codeUnits))
        .map((x) => TopicExample.fromJson(x)));

String topicExampleToJson(List<TopicExample> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class TopicExample {
  @Id(assignable: true)
  final int id;
  final String originalText;
  final String transformedText;
  final String guide;
  final bool completed;
  final int topic;

  TopicExample({
    required this.id,
    required this.originalText,
    required this.transformedText,
    required this.guide,
    required this.completed,
    required this.topic,
  });

  factory TopicExample.fromJson(Map<String, dynamic> json) => TopicExample(
        id: json["id"],
        originalText: json["original_text"],
        transformedText: json["transformed_text"],
        guide: json["guide"],
        completed: json["completed"],
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
