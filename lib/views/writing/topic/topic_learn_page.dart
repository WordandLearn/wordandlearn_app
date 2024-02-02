import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/utils/timer.dart';
import 'package:word_and_learn/views/writing/topic/components/flash_card_container.dart';
import 'package:word_and_learn/views/writing/topic/topic_example_page.dart';

import 'components/topic_learn_appbar.dart';

class TopicLearnPage extends StatefulWidget {
  final Topic topic;
  const TopicLearnPage({super.key, required this.topic});

  @override
  State<TopicLearnPage> createState() => _TopicLearnPageState();
}

class _TopicLearnPageState extends State<TopicLearnPage> {
  late Future<HttpResponse<FlashcardText>> _future;
  final WritingController _writingController = WritingController();
  bool completed = false;

  @override
  void initState() {
    _future = _writingController.getTopicFlashcards(widget.topic.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        backgroundColor: const Color(0xFFFFE999),
        appBar: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding * 2),
          child: TopicLearnAppbar(topic: widget.topic),
        ),
        body: FutureBuilder<HttpResponse<FlashcardText>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingSpinner();
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data!.isSuccess) {
                List<FlashcardText> flashcards = snapshot.data!.models;
                return Column(
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
                      duration: TimerUtil.timeToRead(flashcards.join(" ")),
                      child: CustomPrimaryButton(
                        text: "Next",
                        disabled: !completed,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TopicExamplePage(topic: widget.topic),
                              ));
                        },
                        color: const Color(0xFF060606),
                      ),
                    )
                  ],
                );
              }

              return const Text("UI element for error thing ");
            }));
  }
}
