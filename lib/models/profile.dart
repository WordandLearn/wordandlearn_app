// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  UserClass user;

  User({
    required this.user,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        user: UserClass.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
      };
}

class UserClass {
  String username;
  Role role;
  Profile profile;

  UserClass({
    required this.username,
    required this.role,
    required this.profile,
  });

  static Role roleToEnum(String role) {
    if (role == "T") {
      return Role.teacher;
    } else if (role == "S") {
      return Role.school;
    } else {
      return Role.child;
    }
  }

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        username: json["username"],
        role: roleToEnum(json["role"]),
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "role": role,
        "profile": profile.toJson(),
      };
}

enum Role { teacher, school, child }

List<Profile> profileFromJson(String str) =>
    List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

String profileToJson(List<Profile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class Profile {
  @Id(assignable: true)
  int id;
  String name;
  String? address;
  String? phone;
  String? email;
  bool? isActive;
  String? slug;

  int? school;
  int? grade;
  int user;

  Profile(
      {required this.id,
      required this.name,
      required this.isActive,
      required this.user,
      this.address,
      this.phone,
      this.email,
      this.grade,
      this.slug,
      this.school});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      email: json["email"],
      isActive: json["is_active"],
      slug: json["slug"],
      user: json["user"],
      grade: json["grade"],
      school: json["school"] != null ? json["school"]["id"] : null);

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

  String get firstName {
    return name.split(" ")[0];
  }
}
