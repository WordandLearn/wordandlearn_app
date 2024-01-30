import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/theme.dart';
import 'package:word_and_learn/views/auth/login.dart';
import 'package:word_and_learn/views/home/module_selection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.getTheme(),
      home: const LoginPage(),
    );
  }
}
