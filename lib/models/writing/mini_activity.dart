// To parse this JSON data, do
//
//     final miniActivity = miniActivityFromJson(jsonString);

import 'dart:convert';

import 'package:word_and_learn/objectbox.g.dart';

MiniActivity miniActivityFromJson(String str) =>
    MiniActivity.fromJson(json.decode(utf8.decode(str.codeUnits)));

String miniActivityToJson(MiniActivity data) => json.encode(data.toJson());

@Entity()
class MiniActivity {
  String criteria;
  String? activityText;
  String activityType;
  String activityDescription;

  MiniActivity({
    required this.criteria,
    required this.activityText,
    required this.activityType,
    required this.activityDescription,
  });

  factory MiniActivity.fromJson(Map<String, dynamic> json) => MiniActivity(
        criteria: json["criteria"],
        activityText: json["activity_text"],
        activityType: json["activity_type"],
        activityDescription: json["activity_description"],
      );

  Map<String, dynamic> toJson() => {
        "criteria": criteria,
        "activity_text": activityText,
        "activity_type": activityType,
        "activity_description": activityDescription,
      };
}
