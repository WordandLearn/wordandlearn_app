import 'package:auto_size_text/auto_size_text.dart';
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
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomBackButton(),
        SizedBox(
          width: size.width * 0.7,
          child: Text(
            topic.title,
            // maxFontSize: Theme.of(context).textTheme.titleLarge!.fontSize!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(
          width: 30,
        )
      ],
    );
  }
}
