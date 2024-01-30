import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({super.key, required this.lesson, this.isComplete = true});
  final Lesson lesson;
  final bool isComplete;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Column(
                    children: [
                      Text(
                        "Vocabulary",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isComplete
              ? const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.done,
                        color: Colors.green,
                        size: 20,
                      ),
                      Text(
                        "Lesson Complete",
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  ),
                )
              : const ProgressBar(
                  width: 150,
                  height: 10,
                  progress: 0.2,
                )
        ],
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar(
      {super.key,
      required this.height,
      required this.width,
      this.progress = 0,
      this.color});
  final double height;
  final double width;
  final double progress;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: color ?? Colors.grey,
              borderRadius: BorderRadius.circular(20)),
        ),
        Container(
          width: width * progress,
          height: height,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20)),
        ),
      ],
    );
  }
}
