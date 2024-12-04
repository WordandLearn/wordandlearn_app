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

  String? get error {
    return data is Map && data.containsKey('error') ? data['error'] : null;
  }

  List<String>? get errors {
    if (isSuccess) {
      return null;
    }
    if (data is Map) {
      if (data.containsKey('errors') && data['errors'] is Map) {
        var errors = (data['errors'] as Map).entries.map((entry) {
          if (entry.value is List) {
            try {
              return '${entry.key}: ${(entry.value as List).map((e) => e.toString()).join('\n ')}';
            } catch (e) {
              return '${entry.key}: [Invalid Error Format]';
            }
          } else {
            return '${entry.key}: ${entry.value.toString()}';
          }
        }).toList();
        return errors.cast<String>();
      }
      if (data.containsKey('error')) {
        return [data['error'].toString()];
      }
      return null;
    }
    return null;
  }

  String? get responseMessage {
    return data is Map && data.containsKey('message') ? data['message'] : null;
  }
}
