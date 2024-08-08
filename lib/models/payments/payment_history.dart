// To parse this JSON data, do
//
//     final paymentHistory = paymentHistoryFromJson(jsonString);

import 'dart:convert';

import 'package:word_and_learn/models/payments/payment_models.dart';

List<PaymentHistory> paymentHistoryFromJson(String str) =>
    List<PaymentHistory>.from(
        json.decode(str).map((x) => PaymentHistory.fromJson(x)));

String paymentHistoryToJson(List<PaymentHistory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentHistory extends PaymentModel {
  int user;
  SubscriptionPackage subscription;
  String amount;
  DateTime paidAt;

  PaymentHistory({
    required this.user,
    required this.subscription,
    required this.amount,
    required this.paidAt,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
        user: json["user"],
        subscription: SubscriptionPackage.fromJson(json["subscription"]),
        amount: json["amount"],
        paidAt: DateTime.parse(json["paid_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "subscription": subscription.toJson(),
        "amount": amount,
        "paid_at": paidAt.toIso8601String(),
      };

  String get paidAtFormatted {
    return formattedDate(paidAt);
  }
}
