import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/constants/theme.dart';
import 'package:word_and_learn/utils/navigation_observer.dart';
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
