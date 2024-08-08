import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpResponse<T> {
  final String? message;
  final int statusCode;
  final dynamic data;
  List<T> models = [];
  HttpResponse({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory HttpResponse.fromResponse(http.Response response) {
    return HttpResponse(
      data: json.decode(response.body),
      statusCode: response.statusCode,
      message: response.reasonPhrase,
    );
  }

  bool get isSuccess => statusCode <= 210;

  @override
  String toString() {
    return {
      'message': message,
      'statusCode': statusCode,
      'data': data,
      'models': models,
    }.toString();
  }
}
