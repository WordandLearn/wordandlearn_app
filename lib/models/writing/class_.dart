// To parse this JSON data, do
//
//     final class = classFromJson(jsonString);

import 'dart:convert';

List<Class_> classFromJson(String str) =>
    List<Class_>.from(json.decode(str).map((x) => Class_.fromJson(x)));

String classToJson(List<Class_> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// ignore: camel_case_types
class Class_ {
  int id;
  String name;
  int grade;
  int school;
  int teacher;

  Class_({
    required this.id,
    required this.name,
    required this.grade,
    required this.school,
    required this.teacher,
  });

  factory Class_.fromJson(Map<String, dynamic> json) => Class_(
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
