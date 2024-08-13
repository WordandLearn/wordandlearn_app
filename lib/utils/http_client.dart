import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:word_and_learn/utils/response_handler.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  final ResponseHandler _responseHandler = ResponseHandler();
  HttpClient._internal() {
    onInit();
  }

  String? _authToken;

  Future<void> onInit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _authToken = preferences.getString("authToken");
  }

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

  Map<String, String> getAuthHeaders() {
    return {"Authorization": "Bearer $_authToken"};
  }

  Future<http.Response> post(String url, Map<String, dynamic> body,
      {bool authRequired = true}) async {
    Map<String, String> headers =
        authRequired ? getAuthHeaders() : getHeaders();
    return await http.post(Uri.parse(url), body: body, headers: headers);
  }

  Future<http.Response> put(String url, Map<String, dynamic> body,
      {bool authRequired = true}) async {
    Map<String, String> headers =
        authRequired ? getAuthHeaders() : getHeaders();
    return await http.put(Uri.parse(url), body: body, headers: headers);
  }

  Future<http.Response> get(String url, {bool authRequired = true}) async {
    Map<String, String> headers =
        authRequired ? getAuthHeaders() : getHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);
    _responseHandler.checkResponse(response);

    return response;
  }

  Future<http.Response> delete(String url, {Map? body}) async {
    return await http.delete(Uri.parse(url),
        body: body, headers: getAuthHeaders());
  }

  Future<http.Response> upload(String url,
      {required List<File> files, String key = 'file'}) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(getAuthHeaders());
    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath(key, file.path));
    }
    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  // Future<http.Response> uploadWithKeys(String url, {required Map<String,File> files}) async {
  //   var request = http.MultipartRequest('POST', Uri.parse(url));
  //   request.headers.addAll(getAuthHeaders());
  //   for (var key in files.keys) {
  //     request.files
  //         .add(await http.MultipartFile.fromPath(key, files[key]!.path));
  //   }
  //   var response = await request.send();
  //   return await http.Response.fromStream(response);
  // }

  Future<http.Response> uploadWithKeys(String url,
      {required Map<String, File> files,
      required Map<String, String> body}) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll(getAuthHeaders());
    for (var key in files.keys) {
      request.files
          .add(await http.MultipartFile.fromPath(key, files[key]!.path));
    }
    request.fields.addAll(body);
    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  Future<File> downloadFile(String url) {
    return http.readBytes(Uri.parse(url)).then((bytes) {
      String dir = Directory.systemTemp.path;
      File file = File('$dir/${DateTime.now().millisecondsSinceEpoch}.jpg');
      return file.writeAsBytes(bytes);
    });
  }
}
