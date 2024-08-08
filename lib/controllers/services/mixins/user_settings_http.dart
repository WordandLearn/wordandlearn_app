import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/services/interfaces/user_settings_interface.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/models/settings/alert_settings.dart';
import 'package:http/http.dart' as http;
import 'package:word_and_learn/utils/http_client.dart';

mixin UserSettingsMixin implements UserSettingsInterface {
  final HttpClient _client = HttpClient();
  @override
  Future<AlertSetting?> getUserAlertSettings() async {
    http.Response res = await _client.get(alertSettingsUrl);
    HttpResponse response = HttpResponse.fromResponse(res);

    if (response.isSuccess) {
      AlertSetting alertSetting = AlertSetting.fromJson(response.data);
      return alertSetting;
    }
    return null;
  }

  @override
  Future<AlertSetting> updateUserAlertSettings(Map<String, bool> data) async {
    //convert data to Map<String,String> type cast
    Map<String, String> body =
        data.map((key, value) => MapEntry(key, value.toString()));

    http.Response res = await _client.post(alertSettingsUrl, body);
    HttpResponse response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      AlertSetting alertSetting = AlertSetting.fromJson(response.data);
      return alertSetting;
    }
    throw Exception("Failed to update your notification settings");
  }
}
