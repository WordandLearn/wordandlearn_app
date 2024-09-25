import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/constants/colors.dart';
import 'package:word_and_learn/constants/theme.dart';
import 'package:word_and_learn/utils/navigation_observer.dart';
import 'package:word_and_learn/utils/notification_utils.dart';
import 'package:word_and_learn/utils/objectbox_utils.dart';

import 'package:word_and_learn/views/splash_screen.dart';
import 'package:intl/intl_standalone.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  Gemini.init(apiKey: "AIzaSyDkAOTIsp59llikprmsliWHwFDSeTMdTyA");

  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await ObjectBox.getInstance();
  }
  await initializeDateFormatting(
      'en_US', ""); // Replace 'en_US' with your desired locale.
  await findSystemLocale();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await FirebaseMessaging.instance.requestPermission(provisional: true);
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests...}
    }

    FirebaseMessaging.instance.getToken().then(
      (value) {
        if (value != null) {
          NotificationUtils.registerDeviceToken(value);
        }
      },
    );

    FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) async {
        await NotificationUtils.registerDeviceToken(token);
      },
    );

    FirebaseMessaging.onBackgroundMessage(
        NotificationUtils.firebaseMessagingBackgroundHandler);
  }

  runApp(const MyApp());
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final MyRouteObserver routeObserver = MyRouteObserver();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        if (message.notification != null) {}
        if (navigatorKey.currentContext != null) {
          ScaffoldMessenger.of(navigatorKey.currentContext!)
              .showSnackBar(SnackBar(
                  content: RichText(
                      text: TextSpan(children: [
            const TextSpan(
              text: "Message From Us:",
              style: TextStyle(
                color: AppColors.greyTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: " ${message.notification!.body}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ]))));
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      navigatorKey: navigatorKey,
      title: 'Word & Learn',
      theme: AppTheme.getTheme(),
      home: const SplashScreen(),
    );
  }
}
