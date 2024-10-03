// To parse this JSON data, do
//
//     final compositionUploadCheck = compositionUploadCheckFromJson(jsonString);

import 'dart:convert';

CompositionUploadCheck compositionUploadCheckFromJson(String str) =>
    CompositionUploadCheck.fromJson(json.decode(str));

String compositionUploadCheckToJson(CompositionUploadCheck data) =>
    json.encode(data.toJson());

class CompositionUploadCheck {
  final bool canUpload;
  final String reason;

  CompositionUploadCheck({
    required this.canUpload,
    required this.reason,
  });

  factory CompositionUploadCheck.fromJson(Map<String, dynamic> json) =>
      CompositionUploadCheck(
        canUpload: json["can_upload"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "can_upload": canUpload,
        "reason": reason,
      };
}
