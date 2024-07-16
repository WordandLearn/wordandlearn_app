import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/utils/http_client.dart';
import 'package:http/http.dart' as http;

class AuthenticationController extends GetxController {
  Future<HttpResponse> login(String username, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    HttpClient client = HttpClient();
    http.Response res = await client.post(
        loginEndpoint, {"username": username, "password": password},
        authRequired: false);

    print(res.body);

    HttpResponse<User> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      await client.saveAuthToken(response.data["token"]);
      response.models = [User.fromJson(response.data)];
      preferences.setString('name', response.models.first.user.profile.name);
      await client.saveUserType(response.models.first.user.role.name);
    }
    return response;
  }
}
