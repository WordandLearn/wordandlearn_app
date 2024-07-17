import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:word_and_learn/constants/theme.dart';
import 'package:word_and_learn/views/splash_screen.dart';

void main() {
  Gemini.init(apiKey: "AIzaSyDkAOTIsp59llikprmsliWHwFDSeTMdTyA");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Word & Learn',
      theme: AppTheme.getTheme(),
      home: const SplashScreen(),
    );
  }
}
