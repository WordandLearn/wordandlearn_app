import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;

  HttpClient._internal() {
    onInit();
  }

  String? _authToken;

  void onInit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _authToken = preferences.getString("authToken");
  }

  Future<void> saveAuthToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("authToken", token);
    _authToken = token;
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

  Future<http.Response> get(String url, {bool authRequired = true}) async {
    Map<String, String> headers =
        authRequired ? getAuthHeaders() : getHeaders();

    return await http.get(Uri.parse(url), headers: headers);
  }
}