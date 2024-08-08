// To parse this JSON data, do
//
//     final subscriptionPackage = subscriptionPackageFromJson(jsonString);

import 'dart:convert';

List<SubscriptionPackage> subscriptionPackageFromJson(String str) =>
    List<SubscriptionPackage>.from(
        json.decode(str).map((x) => SubscriptionPackage.fromJson(x)));

String subscriptionPackageToJson(List<SubscriptionPackage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubscriptionPackage {
  String name;
  String description;
  String price;
  int discount;
  bool isYearly;
  int id;
  String tag;

  SubscriptionPackage({
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.isYearly,
    required this.id,
    required this.tag,
  });

  factory SubscriptionPackage.fromJson(Map<String, dynamic> json) =>
      SubscriptionPackage(
        name: json["name"],
        description: json["description"],
        price: json["price"],
        discount: json["discount"],
        isYearly: json["is_yearly"],
        id: json["id"],
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "price": price,
        "discount": discount,
        "is_yearly": isYearly,
        "id": id,
        "tag": tag,
      };
}
