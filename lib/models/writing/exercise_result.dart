// To parse this JSON data, do
//
//     final exerciseResult = exerciseResultFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

List<ExerciseResult> exerciseResultFromJson(String str) =>
    List<ExerciseResult>.from(
        json.decode(str).map((x) => ExerciseResult.fromJson(x)));

String exerciseResultToJson(List<ExerciseResult> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class ExerciseResult {
  @Id(assignable: true)
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String recommendation;
  int score;
  String rubricScore;
  String feedback;
  bool improvement;
  int exercise;

  ExerciseResult({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.recommendation,
    required this.score,
    required this.rubricScore,
    required this.feedback,
    required this.improvement,
    required this.exercise,
  });

  factory ExerciseResult.fromJson(Map<String, dynamic> json) => ExerciseResult(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        recommendation: json["recommendation"],
        score: json["score"],
        rubricScore: json["rubric_score"],
        feedback: json["feedback"],
        improvement: json["improvement"],
        exercise: json["exercise"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "recommendation": recommendation,
        "score": score,
        "rubric_score": rubricScore,
        "feedback": feedback,
        "improvement": improvement,
        "exercise": exercise,
      };

  bool get success {
    return score >= 3;
  }

  String get message {
    if (score == 1) {
      return 'You were below our expectations';
    }
    if (score == 2) {
      return 'You are approching our expectations, try harder';
    }
    if (score == 3) {
      return 'You are at our expectations, keep it up';
    }
    if (score == 4) {
      return 'You are above our expectations, keep it up';
    }
    return 'You are excellent, keep it up';
  }
}
