import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:word_and_learn/utils/response_handler.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  static String? _authToken;
  final ResponseHandler _responseHandler = ResponseHandler();
  HttpClient._internal();

  static Future<void> init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _authToken = preferences.getString("authToken");
  }

  // Future<void> onInit() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   _authToken = preferences.getString("authToken");
  // }

  Future<void> saveAuthToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("authToken", token);
    _authToken = token;
  }

  Future<void> saveUserType(String userType) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("userType", userType);
  }

  Map<String, String> getHeaders() {
    return {};
  }

  Future<Map<String, String>> getAuthHeaders() async {
    if (_authToken != null) {
      return {"X-Authorization": "Bearer $_authToken"};
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? authToken = preferences.getString("authToken");
    _authToken = authToken;
    return {"X-Authorization": "Bearer $authToken"};
  }

  String addTrailingSlash(String url) {
    if (url.endsWith('/')) {
      return url;
    }
    return '$url/';
  }

  Future<http.Response> post(String url, Map<String, dynamic> body,
      {bool authRequired = true}) async {
    Map<String, String>? headers = authRequired ? await getAuthHeaders() : null;
    try {
      return await http.post(Uri.parse(addTrailingSlash(url)),
          body: body, headers: headers);
    } on SocketException {
      ResponseHandler.showNoInternetError();
      rethrow;
    }
  }

  Future<http.Response> put(String url, Map<String, dynamic> body,
      {bool authRequired = true}) async {
    Map<String, String>? headers = authRequired ? await getAuthHeaders() : null;
    try {
      return await http.put(Uri.parse(addTrailingSlash(url)),
          body: body, headers: headers);
    } on SocketException {
      ResponseHandler.showNoInternetError();
      rethrow;
    }
  }

  Future<http.Response> get(String url, {bool authRequired = true}) async {
    Map<String, String>? headers = authRequired ? await getAuthHeaders() : null;
    try {
      final response =
          await http.get(Uri.parse(addTrailingSlash(url)), headers: headers);
      _responseHandler.checkResponse(response);

      return response;
    } on SocketException {
      ResponseHandler.showNoInternetError();
      rethrow;
    }
  }

  Future<http.Response> delete(String url, {Map? body}) async {
    try {
      return await http.delete(Uri.parse(addTrailingSlash(url)),
          body: body, headers: await getAuthHeaders());
    } on SocketException {
      ResponseHandler.showNoInternetError();
      rethrow;
    }
  }

  Future<http.Response> upload(String url,
      {required List<XFile> files, String key = 'file'}) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(addTrailingSlash(url)));
    request.headers.addAll(await getAuthHeaders());
    for (var file in files) {
      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes(
            key, await file.readAsBytes(),
            filename: file.name));
      } else {
        request.files.add(await http.MultipartFile.fromPath(key, file.path));
      }
    }
    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  // Future<http.Response> uploadWithKeys(String url, {required Map<String,File> files}) async {
  //   var request = http.MultipartRequest('POST', Uri.parse(addTrailingSlash(url)));
  //   request.headers.addAll(getAuthHeaders());
  //   for (var key in files.keys) {
  //     request.files
  //         .add(await http.MultipartFile.fromPath(key, files[key]!.path));
  //   }
  //   var response = await request.send();
  //   return await http.Response.fromStream(response);
  // }

  Future<http.Response> uploadWithKeys(String url,
      {required Map<String, XFile> files,
      required Map<String, String> body}) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(addTrailingSlash(url)));

    request.headers.addAll(await getAuthHeaders());
    for (var key in files.keys) {
      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes(
            key, await files[key]!.readAsBytes(),
            filename: files[key]!.name));
      } else {
        request.files
            .add(await http.MultipartFile.fromPath(key, files[key]!.path));
      }
    }
    request.fields.addAll(body);
    var response = await request.send();
    try {
      return await http.Response.fromStream(response);
    } on SocketException {
      ResponseHandler.showNoInternetError();
      rethrow;
    }
  }

  Future<File> downloadFile(String url) {
    return http.readBytes(Uri.parse(addTrailingSlash(url))).then((bytes) {
      String dir = Directory.systemTemp.path;
      File file = File('$dir/${DateTime.now().millisecondsSinceEpoch}.jpg');
      return file.writeAsBytes(bytes);
    });
  }
}
