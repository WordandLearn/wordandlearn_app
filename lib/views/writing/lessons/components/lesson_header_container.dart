import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/writing/models.dart';

class LessonHeaderContainer extends StatelessWidget {
  const LessonHeaderContainer({
    super.key,
    required this.lesson,
  });
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
            vertical: defaultPadding, horizontal: defaultPadding * 2),
        decoration: BoxDecoration(
            color: lesson.color ?? Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          lesson.title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w600, fontSize: 18),
        ));
  }
}
