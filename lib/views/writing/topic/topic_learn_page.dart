import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/example.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/utils/timer.dart';
import 'package:word_and_learn/views/writing/topic/components/flash_card_container.dart';
import 'package:word_and_learn/views/writing/topic/topic_example_page.dart';

import 'components/topic_learn_appbar.dart';

List<FlashcardText> flashcards = [
  FlashcardText(
      text:
          "Let us look at synonyms. Synonyms are like word twins! They are different words but mean something very similar."),
  FlashcardText(
      text:
          'For example, in your story about a visit to grandmas house, you wrote "happy." What if we try its twin like "joyful" or "cheerful"? Its like painting your story with more colours!')
];

class TopicLearnPage extends StatefulWidget {
  final Topic topic;
  const TopicLearnPage({super.key, required this.topic});

  @override
  State<TopicLearnPage> createState() => _TopicLearnPageState();
}

class _TopicLearnPageState extends State<TopicLearnPage> {
  bool completed = false;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        backgroundColor: const Color(0xFFFFE999),
        appBar: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding * 2),
          child: TopicLearnAppbar(topic: widget.topic),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlashCardContainer(
              flashcards: flashcards,
              onCompleted: () {
                setState(() {
                  completed = true;
                });
              },
            ),
            TimedWidget(
              duration: TimerUtil.timeToRead(flashcards[0].text),
              child: CustomPrimaryButton(
                text: "Next",
                disabled: !completed,
                onPressed: () {
                  Navigator.pushNamed(context, "/writing/topics/learn/example");
                },
                color: const Color(0xFF060606),
              ),
            )
          ],
        ));
  }
}
