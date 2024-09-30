// To parse this JSON data, do
//
//     final userSubscription = userSubscriptionFromJson(jsonString);

import 'dart:convert';

import 'package:word_and_learn/models/payments/payment_models.dart';

List<UserSubscription> userSubscriptionFromJson(String str) =>
    List<UserSubscription>.from(
        json.decode(str).map((x) => UserSubscription.fromJson(x)));

String userSubscriptionToJson(List<UserSubscription> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserSubscription {
  int id;
  SubscriptionPackage subscription;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime endDate;
  bool cancelled;
  int user;
  dynamic payment;
  dynamic request;

  UserSubscription({
    required this.id,
    required this.subscription,
    required this.createdAt,
    required this.updatedAt,
    required this.endDate,
    required this.cancelled,
    required this.user,
    required this.payment,
    required this.request,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) =>
      UserSubscription(
        id: json["id"],
        subscription: SubscriptionPackage.fromJson(json["subscription"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        endDate: DateTime.parse(json["end_date"]),
        cancelled: json["cancelled"],
        user: json["user"],
        payment: json["payment"],
        request: json["request"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subscription": subscription.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "cancelled": cancelled,
        "user": user,
        "payment": payment,
        "request": request,
      };

  bool get isPaid {
    return DateTime.now().isBefore(endDate);
  }
}
