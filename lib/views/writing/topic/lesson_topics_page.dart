import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/models/models.dart';

class LessonTopicsPage extends StatelessWidget {
  const LessonTopicsPage({super.key, required this.lesson});
  final Lesson lesson;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: ListView(
      children: [Text("HERE WE GOO")],
    ));
  }
}
