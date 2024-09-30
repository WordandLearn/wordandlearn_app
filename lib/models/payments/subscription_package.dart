// To parse this JSON data, do
//
//     final subscriptionPackage = subscriptionPackageFromJson(jsonString);

import 'dart:convert';

import 'package:word_and_learn/models/writing/color_model.dart';

List<SubscriptionPackage> subscriptionPackageFromJson(String str) =>
    List<SubscriptionPackage>.from(
        json.decode(str).map((x) => SubscriptionPackage.fromJson(x)));

String subscriptionPackageToJson(List<SubscriptionPackage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubscriptionPackage extends ColorModel {
  int id;
  List<SubscriptionConstraint> constraints;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String description;
  String tag;
  String price;
  int discount;
  String interval;
  String currency;

  SubscriptionPackage({
    required this.id,
    required this.constraints,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    required this.tag,
    required this.price,
    required this.discount,
    required this.interval,
    required this.currency,
  });

  factory SubscriptionPackage.fromJson(Map<String, dynamic> json) =>
      SubscriptionPackage(
        id: json["id"],
        constraints: List<SubscriptionConstraint>.from(
            json["constraints"].map((x) => SubscriptionConstraint.fromJson(x))),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        name: json["name"],
        description: json["description"],
        tag: json["tag"],
        price: json["price"],
        discount: json["discount"],
        interval: json["interval"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "constraints": List<dynamic>.from(constraints.map((x) => x.toJson())),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "name": name,
        "description": description,
        "tag": tag,
        "price": price,
        "discount": discount,
        "interval": interval,
        "currency": currency,
      };

  @override
  //override equal check
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is SubscriptionPackage) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => id;
}

class SubscriptionConstraint {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String constraint;
  int value;
  int subscription;

  SubscriptionConstraint({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.constraint,
    required this.value,
    required this.subscription,
  });

  factory SubscriptionConstraint.fromJson(Map<String, dynamic> json) =>
      SubscriptionConstraint(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        constraint: json["constraint"],
        value: json["value"],
        subscription: json["subscription"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "constraint": constraint,
        "value": value,
        "subscription": subscription,
      };
}
