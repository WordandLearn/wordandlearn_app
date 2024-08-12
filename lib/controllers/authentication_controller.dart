import 'package:get/get.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/utils/http_client.dart';
import 'package:http/http.dart' as http;

class AuthenticationController extends GetxController {
  final HttpClient client = HttpClient();

  Future<void> setToken(String token) {
    return client.saveAuthToken(token);
  }

  Future<HttpResponse> login(String username, String password) async {
    http.Response res = await client.post(
        loginEndpoint, {"username": username, "password": password},
        authRequired: false);

    HttpResponse<User> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      await client.saveAuthToken(response.data["token"]);
      response.models = [User.fromJson(response.data)];
      await client.saveUserType(response.models.first.user.role.name);
    }
    return response;
  }

  Future<HttpResponse> signUp(Map<String, dynamic> body) async {
    http.Response res =
        await client.post(registerEndpoint, body, authRequired: false);
    HttpResponse<User> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      await client.saveAuthToken(response.data["token"]);
      response.models = [User.fromJson(response.data)];
    }
    return response;
  }

  Future<HttpResponse> activateEmail(String code) async {
    http.Response res =
        await client.post("$authUrl/email/activate/", {"code": code});
    HttpResponse<User> response = HttpResponse.fromResponse(res);
    return response;
  }

  Future<HttpResponse> initiatePasswordReset(String email) async {
    http.Response res = await client.post(
        "$authUrl/password/reset/initiate/", {"email": email},
        authRequired: false);
    HttpResponse<User> response = HttpResponse.fromResponse(res);
    return response;
  }

  Future<HttpResponse> validateResetCode(String code) async {
    http.Response res = await client.post(
        "$authUrl/password/reset/validate/", {"code": code},
        authRequired: false);
    HttpResponse<User> response = HttpResponse.fromResponse(res);
    return response;
  }

  Future<HttpResponse> resetPassword(
      {required String uid,
      required String token,
      required Map<String, dynamic> body}) async {
    http.Response res = await client.post(
        "$authUrl/password/reset/$uid/$token/", body,
        authRequired: false);
    HttpResponse<User> response = HttpResponse.fromResponse(res);
    return response;
  }
}
