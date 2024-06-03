// To parse this JSON data, do
//
//     final class = classFromJson(jsonString);

import 'dart:convert';

List<Class> classFromJson(String str) =>
    List<Class>.from(json.decode(str).map((x) => Class.fromJson(x)));

String classToJson(List<Class> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Class {
  int id;
  String name;
  int grade;
  int school;
  int teacher;

  Class({
    required this.id,
    required this.name,
    required this.grade,
    required this.school,
    required this.teacher,
  });

  factory Class.fromJson(Map<String, dynamic> json) => Class(
        id: json["id"],
        name: json["name"],
        grade: json["grade"],
        school: json["school"],
        teacher: json["teacher"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "grade": grade,
        "school": school,
        "teacher": teacher,
      };

  String get className {
    return "$grade $name";
  }
}
