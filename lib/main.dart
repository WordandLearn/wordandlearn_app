import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/constants/theme.dart';
import 'package:word_and_learn/utils/objectbox_utils.dart';
import 'package:word_and_learn/views/splash_screen.dart';

void main() async {
  Gemini.init(apiKey: "AIzaSyDkAOTIsp59llikprmsliWHwFDSeTMdTyA");

  WidgetsFlutterBinding.ensureInitialized();

  await ObjectBox.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Word & Learn',
      theme: AppTheme.getTheme(),
      home: const SplashScreen(),
    );
  }
}
