import 'package:flutter/material.dart';
import 'package:word_and_learn/components/fade_indexed_stack.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/topic/topic_example_page.dart';

import 'components/topic_bottom_navbar.dart';
import 'topic_notes_page.dart';

class TopicLearnPage extends StatefulWidget {
  final Topic topic;
  final Lesson? lesson;
  const TopicLearnPage({super.key, required this.topic, this.lesson});

  @override
  State<TopicLearnPage> createState() => _TopicLearnPageState();
}

class _TopicLearnPageState extends State<TopicLearnPage> {
  bool completed = false;

  @override
  void initState() {
    super.initState();
  }

  int activePage = 0;
  double progress = 0;
  List<bool> completedStatus = [false, false, false];
  @override
  Widget build(BuildContext context) {
    List<String> invalidClickErrors = [
      "",
      "Complete reading all the notes to see examples.",
      "Complete reading the examples to do your exercise."
    ];
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: TopicBottomNavBar(
          topic: widget.topic,
          progress: progress,
          onChanged: (index) {
            setState(() {
              activePage = index;
            });
          },
          completedStatus: completedStatus,
          onInvalidClick: (index) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(invalidClickErrors[index]),
            ));
          },
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: buildAppbar(context),
            ),
            Expanded(
              child: FadeIndexedStack(
                duration: const Duration(milliseconds: 300),
                index: activePage,
                children: [
                  TopicNotesPage(
                    topic: widget.topic,
                    lesson: widget.lesson!,
                    onProgress: (progress) {
                      setState(() {
                        this.progress = progress;
                      });
                    },
                  ),
                  TopicExamplePage(topic: widget.topic),
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildAppbar(
    BuildContext context,
  ) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.chevron_left,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    widget.topic.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
