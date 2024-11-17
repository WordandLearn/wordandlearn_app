// To parse this JSON data, do
//
//     final session = sessionFromJson(jsonString);

import 'dart:convert';

List<Session> sessionFromJson(String str) =>
    List<Session>.from(json.decode(str).map((x) => Session.fromJson(x)));

String sessionToJson(List<Session> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// @Entity()
class Session {
  // @Id(assignable: true)
  final int id;
  final DateTime updatedAt;
  final String text;
  final String? title;
  final String? imageUrl;
  final DateTime createdAt;
  final String? reportUrl;
  final String? summary;
  final int profile;
  bool completed;

  Session({
    required this.id,
    required this.updatedAt,
    required this.text,
    required this.title,
    required this.imageUrl,
    required this.createdAt,
    required this.reportUrl,
    required this.summary,
    required this.profile,
    this.completed = false,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json["id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        text: json["text"],
        title: json["title"],
        imageUrl: json["image_url"],
        createdAt: DateTime.parse(json["created_at"]),
        reportUrl: json["report_url"],
        summary: json["summary"],
        profile: json["profile"],
        completed: json["completed"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "updated_at": updatedAt.toIso8601String(),
        "text": text,
        "title": title,
        "image_url": imageUrl,
        "created_at": createdAt.toIso8601String(),
        "report_url": reportUrl,
        "summary": summary,
        "profile": profile,
      };

  String get titleOrDefault => title ?? "Untitled Composition";

  @override
  String toString() {
    return titleOrDefault;
  }
}

class Progress {
  final int completed;
  final int total;

  Progress({
    required this.completed,
    required this.total,
  });

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
        completed: json["completed"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "completed": completed,
        "total": total,
      };
}

// @Entity()
class CurrentSession {
  // @Id(assignable: true)
  int id;
  Session? session;
  // @Property(type: PropertyType.dateNano)
  final DateTime dateOpened;

  CurrentSession({required this.dateOpened, this.id = 0});
}
