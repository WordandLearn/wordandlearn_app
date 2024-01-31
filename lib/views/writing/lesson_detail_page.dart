import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/components/lesson_header_container.dart';
import 'package:word_and_learn/views/writing/topic/lesson_topics_page.dart';

const String sampleText =
    "Every story is like a painting, and words are your colours. Today, we will add more colours to your palette by learning new words that you can use to describe your experiences in a more vivid and interesting way.";

class LessonDetailPage extends StatelessWidget {
  const LessonDetailPage({super.key, required this.lesson});
  final Lesson lesson;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: defaultPadding),
          child: LessonHeaderContainer(
            text: 'Expanding Vocabulary',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: Text(
            sampleText,
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 22),
          ),
        ),
        SizedBox(
          width: 300,
          child: PrimaryButton(
            onPressed: () {
              Navigator.pushNamed(context, "/writing/topics");
            },
            color: Theme.of(context).colorScheme.secondary,
            child: const Text(
              "Go To Lesson",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
