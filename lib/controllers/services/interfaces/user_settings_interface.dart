import 'package:word_and_learn/models/settings/alert_settings.dart';

abstract class UserSettingsInterface {
  Future<AlertSetting?> getUserAlertSettings();
  Future<AlertSetting?> updateUserAlertSettings(Map<String, bool> data);
}
