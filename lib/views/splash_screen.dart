import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/views/auth/login.dart';
import 'package:word_and_learn/views/teachers/home.dart';
import 'package:word_and_learn/views/writing/lessons/lessons_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> navigateTo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (context.mounted) {
      if (preferences.containsKey("authToken")) {
        if (preferences.containsKey("userType")) {
          if (preferences.getString("userType") == "child") {
            Get.put(WritingController());
            if (mounted) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LessonsPage(),
                  ));
            } else if (preferences.getString("userType") == "teacher") {
              Get.put(TeacherController());
              if (mounted) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeachersHome(),
                    ));
              }
            }
          }
        }
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ));
      }
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), navigateTo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoadingSpinner(),
      ),
    );
  }
}
