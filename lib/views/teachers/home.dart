import 'package:flutter/material.dart';
import 'package:word_and_learn/views/teachers/classes.dart';

class TeachersHome extends StatefulWidget {
  const TeachersHome({super.key});

  @override
  State<TeachersHome> createState() => _TeachersHomeState();
}

class _TeachersHomeState extends State<TeachersHome> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: TeacherClassesPage()));
  }
}
