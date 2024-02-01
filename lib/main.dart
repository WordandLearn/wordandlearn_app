import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/theme.dart';
import 'package:word_and_learn/models/example.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/auth/login.dart';
import 'package:word_and_learn/views/home/module_selection.dart';
import 'package:word_and_learn/views/writing/exercise.dart';
import 'package:word_and_learn/views/writing/home.dart';
import 'package:word_and_learn/views/writing/lessons_page.dart';
import 'package:word_and_learn/views/writing/topic/lesson_topics_page.dart';
import 'package:word_and_learn/views/writing/topic/topic_example_page.dart';
import 'package:word_and_learn/views/writing/topic/topic_learn_page.dart';

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
      initialRoute: "/login",
      routes: {
        "/login": (context) => const LoginPage(),
        "/": (context) => const ModuleSelection(),
        "/writing": (context) => const WritingHome(),
        "/writing/lessons": (context) => const LessonsPage(),
        "/writing/topics": (context) => LessonTopicsPage(lesson: Lesson()),
        "/writing/topics/learn": (context) =>
            TopicLearnPage(topic: Topic(name: "Adjectives")),
        "/writing/topics/learn/example": (context) => TopicExamplePage(
              examples: [
                Example(
                    beforeText: "I always feel happy at grandma’s house.",
                    afterText: "I always feel joyful at grandma’s house.",
                    guideText:
                        "Notice how the word happy has been changed to joyful? Using different words that mean the same thing makes your writing more interesting and fun! Let’s look at more examples..."),
                Example(
                    beforeText: "I always feel sad at grandma’s house.",
                    afterText: "I always feel melancholic at grandma’s house.",
                    guideText:
                        "melancholic we changed it to give more meaning to the story"),
              ],
              topic: Topic(name: "Adjectives"),
            ),
        "/writing/topics/exercise": (context) => const ExercisePage()
      },
      title: 'Flutter Demo',
      theme: AppTheme.getTheme(),
    );
  }
}
