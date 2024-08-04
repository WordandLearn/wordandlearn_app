// To parse this JSON data, do
//
//     final alertSetting = alertSettingFromJson(jsonString);

import 'dart:convert';

AlertSetting alertSettingFromJson(String str) =>
    AlertSetting.fromJson(json.decode(str));

String alertSettingToJson(AlertSetting data) => json.encode(data.toJson());

class AlertSetting {
  int? id;
  bool email;
  bool sms;
  bool push;
  int? user;

  AlertSetting({
    required this.id,
    required this.email,
    required this.sms,
    required this.push,
    required this.user,
  });

  factory AlertSetting.fromJson(Map<String, dynamic> json) => AlertSetting(
        id: json["id"],
        email: json["email"],
        sms: json["sms"],
        push: json["push"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "sms": sms,
        "push": push,
        "user": user,
      };
}
