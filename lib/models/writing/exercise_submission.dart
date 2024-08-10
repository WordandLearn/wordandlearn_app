// To parse this JSON data, do
//
//     final exerciseSubmission = exerciseSubmissionFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

List<ExerciseSubmission> exerciseSubmissionFromJson(String str) =>
    List<ExerciseSubmission>.from(
        json.decode(str).map((x) => ExerciseSubmission.fromJson(x)));

String exerciseSubmissionToJson(List<ExerciseSubmission> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class ExerciseSubmission {
  @Id(assignable: true)
  final int id;
  final DateTime createdAt;
  final String imageUrl;
  final String? text;
  final bool processed;
  final int exercise;

  ExerciseSubmission({
    required this.id,
    required this.createdAt,
    required this.imageUrl,
    required this.text,
    required this.processed,
    required this.exercise,
  });

  factory ExerciseSubmission.fromJson(Map<String, dynamic> json) =>
      ExerciseSubmission(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        imageUrl: json["image_url"],
        text: json["text"],
        processed: json["processed"],
        exercise: json["exercise"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "image_url": imageUrl,
        "text": text,
        "processed": processed,
        "exercise": exercise,
      };
}
