import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/models/models.dart';

class TopicLearnAppbar extends StatelessWidget {
  const TopicLearnAppbar({
    super.key,
    required this.topic,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomBackButton(),
        Text(
          topic.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          width: 30,
        )
      ],
    );
  }
}
