import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';

class CurrentLessonCard extends StatelessWidget {
  const CurrentLessonCard({
    super.key,
    this.lesson,
  });
  final Lesson? lesson;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      width: 300,
      padding: const EdgeInsets.all(defaultPadding * 2),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20)),
      child: lesson != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Current Lesson",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(
                              height: defaultPadding / 2,
                            ),
                            Text(
                              "Expanding Vocabulary",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 200,
                              child: Text(
                                  "Learn new words to make your composition enticing and more engaging. "),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const Center(
                  child: _LessonTopicIndicators(
                    lessonCount: 5,
                    currentLessonIndex: 2,
                  ),
                )
              ],
            )
          : const Text("No current Lesson"),
    );
  }
}

class _LessonTopicIndicators extends StatelessWidget {
  const _LessonTopicIndicators(
      {super.key, required this.lessonCount, this.currentLessonIndex = 0});
  final int lessonCount;
  final int currentLessonIndex;
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
            lessonCount,
            (index) => Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(right: defaultPadding),
                  decoration: BoxDecoration(
                      color: index <= currentLessonIndex
                          ? Colors.white
                          : const Color.fromARGB(136, 150, 150, 150),
                      shape: BoxShape.circle),
                  child: Center(child: Text((index + 1).toString())),
                )));
  }
}
