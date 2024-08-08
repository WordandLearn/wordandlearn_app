import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/writing/models.dart';

class ExerciseAppbar extends StatelessWidget {
  const ExerciseAppbar({
    super.key,
    required this.topic,
    this.progress = 0.1,
    required this.onBack,
  });

  final Topic topic;
  final double progress;
  final void Function() onBack;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  size: 30,
                ),
                onPressed: () {
                  onBack();
                },
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: Text(
                  topic.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            child: FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                width: size.width,
                height: 4,
                decoration: BoxDecoration(color: topic.darkerColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
