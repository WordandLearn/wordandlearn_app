// To parse this JSON data, do
//
//     final school = schoolFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

List<School> schoolFromJson(String str) =>
    List<School>.from(json.decode(str).map((x) => School.fromJson(x)));

String schoolToJson(List<School> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class School {
  @Id(assignable: true)
  int id;
  String name;
  String? address;
  String? phone;
  String? email;
  bool? isActive;
  String? slug;
  int? user;

  School({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    this.isActive,
    this.slug,
    this.user,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        email: json["email"],
        isActive: json["is_active"],
        slug: json["slug"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "phone": phone,
        "email": email,
        "is_active": isActive,
        "slug": slug,
        "user": user,
      };
}
