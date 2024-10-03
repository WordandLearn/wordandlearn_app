import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/components/fade_indexed_stack.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/writing/exercise/exercise_page.dart';
import 'package:word_and_learn/views/writing/lessons/components/session_error_dialog.dart';
import 'package:word_and_learn/views/writing/lessons/components/session_success_dialog.dart';
import 'package:word_and_learn/views/writing/topic/topic_example_page.dart';

import 'components/topic_bottom_navbar.dart';
import 'topic_notes_page.dart';

class TopicLearnPage extends StatefulWidget {
  final Topic topic;
  final Lesson? lesson;
  final void Function() onCompleted;
  const TopicLearnPage(
      {super.key, required this.topic, this.lesson, required this.onCompleted});

  @override
  State<TopicLearnPage> createState() => _TopicLearnPageState();
}

class _TopicLearnPageState extends State<TopicLearnPage> {
  bool completed = false;
  final WritingController writingController = Get.find<WritingController>();
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
            showDialog(
              context: context,
              builder: (context) {
                return SessionErrorDialog(
                  title: "You cannot access this right now",
                  reason: invalidClickErrors[index],
                );
              },
            );
          },
        ),
        body: SafeArea(
          child: Column(
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
                      onComplete: () {
                        setState(() {
                          completedStatus[0] = true;
                        });
                      },
                      onProgress: (progress) {
                        setState(() {
                          this.progress = progress;
                          if (progress == 1) {
                            completedStatus[0] = true;
                          }
                        });
                      },
                    ),
                    TopicExamplePage(
                      topic: widget.topic,
                      onComplete: () {
                        writingController.markTopicCompleted(widget.topic);
                        setState(() {
                          completedStatus[1] = true;
                          widget.topic.completed = true;
                        });
                        widget.onCompleted();

                        showDialog(
                          context: context,
                          builder: (context) {
                            return SessionSuccessDialog(
                                title: "Congratulations!",
                                reason:
                                    "You have completed the learning activity on this Topic. You can now try out the exercise",
                                action: TapBounce(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return ExercisePage(
                                          topic: widget.topic,
                                        );
                                      }));
                                    },
                                    child: const PrimaryIconButton(
                                        text: "Exercise",
                                        icon: Icon(
                                          Icons.chevron_right,
                                          color: Colors.white,
                                          size: 17,
                                        ))));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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
