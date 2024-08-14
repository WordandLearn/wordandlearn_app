import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/utils/http_client.dart';

class NotificationUtils {
  static final HttpClient client = HttpClient();

  static Future<void> registerDeviceToken(String token) async {
    Future.delayed(const Duration(seconds: 2), () async {
      await client
          .post("$settingsUrl/notification/fcm/register/", {"token": token});
    });
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}
}
