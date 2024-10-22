import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      final user = User.fromJson(response.data);
      response.models = [user];
      await client.saveUserType(response.models.first.user.role.name);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (user.user.profile != null) {
        preferences.setInt("profile_id", user.user.profile!.id);
      }
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

  Future<HttpResponse> activateEmail(String email, String code) async {
    http.Response res = await client
        .post("$authUrl/email/activate/", {"code": code, "email": email});
    HttpResponse<User> response = HttpResponse.fromResponse(res);
    return response;
  }

  Future<HttpResponse> resendActivationEmail(String email) async {
    http.Response res = await client.post(
        "$authUrl/email/activate/resend/", {"email": email},
        authRequired: false);
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

  Future<HttpResponse<ChildProfileDetails>> createProfile(
      Map<String, dynamic> body) async {
    http.Response res = await client.post("$authUrl/profile/create/", body);
    HttpResponse<ChildProfileDetails> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      final profile = ChildProfileDetails.fromJson(response.data);
      response.models = [profile];
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt("profile_id", profile.id);
    }
    return response;
  }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
