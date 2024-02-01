import 'package:get/get.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/utils/http_client.dart';
import 'package:http/http.dart' as http;

class AuthenticationController extends GetxController {
  Future<HttpResponse> login(String username, String password) async {
    HttpClient client = HttpClient();

    http.Response res = await client.post(
        loginEndpoint, {"username": username, "password": password},
        authRequired: false);

    HttpResponse response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      await client.saveAuthToken(response.data["token"]);
    }
    return response;
  }
}
