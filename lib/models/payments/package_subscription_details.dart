// To parse this JSON data, do
//
//     final packageSubscriptionDetails = packageSubscriptionDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';

List<PackageSubscriptionDetails> packageSubscriptionDetailsFromJson(
        String str) =>
    List<PackageSubscriptionDetails>.from(
        json.decode(str).map((x) => PackageSubscriptionDetails.fromJson(x)));

String packageSubscriptionDetailsToJson(
        List<PackageSubscriptionDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PackageSubscriptionDetails {
  String message;
  bool active;
  bool isTrial;
  bool trialEligible;
  TrialDetails? trialDetails;
  SubscriptionDetails? subscriptionDetails;

  PackageSubscriptionDetails({
    required this.message,
    required this.active,
    required this.isTrial,
    required this.trialEligible,
    this.trialDetails,
    this.subscriptionDetails,
  });

  factory PackageSubscriptionDetails.fromJson(Map<String, dynamic> json) =>
      PackageSubscriptionDetails(
        message: json["message"],
        active: json["active"],
        isTrial: json["is_trial"],
        trialEligible: json["trial_eligible"],
        trialDetails: json["trial_details"] == null
            ? null
            : TrialDetails.fromJson(json["trial_details"]),
        subscriptionDetails: json["subscription_details"] == null
            ? null
            : SubscriptionDetails.fromJson(json["subscription_details"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "active": active,
        "is_trial": isTrial,
        "trial_eligible": trialEligible,
        "trial_details": trialDetails?.toJson(),
        "subscription_details": subscriptionDetails?.toJson(),
      };
}

class SubscriptionDetails extends PaymentModel {
  int user;
  SubscriptionPackage subscription;
  bool cancelled;
  DateTime paidAt;
  DateTime endDate;
  DateTime createdAt;

  SubscriptionDetails({
    required this.user,
    required this.subscription,
    required this.cancelled,
    required this.paidAt,
    required this.endDate,
    required this.createdAt,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) =>
      SubscriptionDetails(
        user: json["user"],
        subscription: SubscriptionPackage.fromJson(json["subscription"]),
        cancelled: json["cancelled"],
        paidAt: DateTime.parse(json["paid_at"]),
        endDate: DateTime.parse(json["end_date"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "subscription": subscription.toJson(),
        "cancelled": cancelled,
        "paid_at": paidAt.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };

  String get paidAtFormatted {
    return formattedDate(paidAt);
  }

  String get endDateFormatted {
    return formattedDate(endDate);
  }

  bool get isPaid {
    return paidAt.isBefore(DateTime.now());
  }
}

class TrialDetails {
  SubscriptionPackage subscription;
  int period;
  DateTime createdAt;
  DateTime endDate;
  int id;

  TrialDetails({
    required this.subscription,
    required this.period,
    required this.createdAt,
    required this.endDate,
    required this.id,
  });

  factory TrialDetails.fromJson(Map<String, dynamic> json) => TrialDetails(
        subscription: SubscriptionPackage.fromJson(json["subscription"]),
        period: json["period"],
        createdAt: DateTime.parse(json["created_at"]),
        endDate: DateTime.parse(json["end_date"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "subscription": subscription.toJson(),
        "period": period,
        "created_at": createdAt.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "id": id,
      };

  String formattedDate(DateTime date) {
    //Format date to be like Aug 12,2024
    return DateFormat("MMM dd,yyyy").format(date);
  }

  String get endDateFormatted {
    return formattedDate(endDate);
  }

  String get createdAtFormatted {
    return formattedDate(createdAt);
  }
}
