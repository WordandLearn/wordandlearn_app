// To parse this JSON data, do
//
//     final pesaPalRequest = pesaPalRequestFromJson(jsonString);

import 'dart:convert';

PesaPalRequest pesaPalRequestFromJson(String str) =>
    PesaPalRequest.fromJson(json.decode(str));

String pesaPalRequestToJson(PesaPalRequest data) => json.encode(data.toJson());

class PesaPalRequest {
  final String orderTrackingId;
  final String merchantReference;
  final String redirectUrl;
  final dynamic error;
  final String status;

  PesaPalRequest({
    required this.orderTrackingId,
    required this.merchantReference,
    required this.redirectUrl,
    required this.error,
    required this.status,
  });

  factory PesaPalRequest.fromJson(Map<String, dynamic> json) => PesaPalRequest(
        orderTrackingId: json["order_tracking_id"],
        merchantReference: json["merchant_reference"],
        redirectUrl: json["redirect_url"],
        error: json["error"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "order_tracking_id": orderTrackingId,
        "merchant_reference": merchantReference,
        "redirect_url": redirectUrl,
        "error": error,
        "status": status,
      };
}
