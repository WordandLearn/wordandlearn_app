import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/components/lesson_header_container.dart';

import 'components/topic_progress.dart';

List<Topic> topics = [
  Topic(name: "Synonyms & Opposites", excerise: Excerise(isCompleted: true)),
  Topic(name: "Adjectives", excerise: Excerise(isCompleted: false)),
  Topic(name: "Adverbs", excerise: Excerise(isCompleted: false)),
];

class LessonTopicsPage extends StatelessWidget {
  const LessonTopicsPage({super.key, required this.lesson});
  final Lesson lesson;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Row(
              children: [CustomBackButton()],
            ),
          ),
          const LessonHeaderContainer(text: "Expanding Vocabulary"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
            child: TopicProgress(topics: topics),
          )
        ],
      ),
    ));
  }
}
