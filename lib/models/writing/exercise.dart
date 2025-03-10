// To parse this JSON data, do
//
//     final exercise = exerciseFromJson(jsonString);

import 'dart:convert';

import 'package:word_and_learn/models/writing/models.dart';

List<Exercise> exerciseFromJson(String str) =>
    List<Exercise>.from(json.decode(str).map((x) => Exercise.fromJson(x)));

String exerciseToJson(List<Exercise> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Exercise extends BaseModel {
  final int id;
  final List<BaseModel>? results;
  final List<BaseModel>? submissions;
  final String description;
  final String? test;
  final String aim;
  final String? difficulty;
  final int topic;
  final int? lesson;
  bool completed;

  Exercise({
    required this.id,
    this.results,
    this.submissions,
    this.completed = false,
    required this.description,
    required this.test,
    required this.aim,
    required this.difficulty,
    required this.topic,
    required this.lesson,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
      id: json["id"],
      // results: json["results"],
      // submissions: json["submissions"],
      description: json["description"],
      test: json["test"],
      aim: json["aim"],
      difficulty: json["difficulty"],
      topic: json["topic"],
      lesson: json["lesson"],
      completed: json["completed"] ?? false);

  Map<String, dynamic> toJson() => {
        "id": id,
        // "results": results,
        // "submissions": submissions,
        "description": description,
        "test": test,
        "aim": aim,
        "difficulty": difficulty,
        "topic": topic,
        "lesson": lesson,
      };
}
