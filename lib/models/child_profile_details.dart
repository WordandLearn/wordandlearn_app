// To parse this JSON data, do
//
//     final childProfileDetails = childProfileDetailsFromJson(jsonString);

import 'dart:convert';

ChildProfileDetails childProfileDetailsFromJson(String str) =>
    ChildProfileDetails.fromJson(json.decode(str));

String childProfileDetailsToJson(ChildProfileDetails data) =>
    json.encode(data.toJson());

class ChildProfileDetails {
  String name;
  DateTime dateOfBirth;
  String gender;
  int grade;
  int id;

  ChildProfileDetails({
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.grade,
    required this.id,
  });

  factory ChildProfileDetails.fromJson(Map<String, dynamic> json) =>
      ChildProfileDetails(
        name: json["name"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        gender: json["gender"],
        grade: json["grade"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "grade": grade,
        "id": id,
      };

  String get firstName {
    return name.split(" ")[0];
  }

  String get lastName {
    return name.split(" ")[1];
  }
}
