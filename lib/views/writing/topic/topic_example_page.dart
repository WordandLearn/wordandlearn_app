import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/writing/lessons/components/session_error_dialog.dart';
import 'package:word_and_learn/views/writing/topic/components/topic_example_card.dart';

class TopicExamplePage extends StatefulWidget {
  const TopicExamplePage(
      {super.key, required this.topic, required this.onComplete});
  final Topic topic;
  final void Function() onComplete;

  @override
  State<TopicExamplePage> createState() => _TopicExamplePageState();
}

class _TopicExamplePageState extends State<TopicExamplePage> {
  final WritingController _writingController = WritingController();
  late Future<List<Example>?> _future;

  @override
  void initState() {
    _future = _writingController.getTopicExamples(widget.topic.id);
    super.initState();
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Example>?>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: size.height * 0.6,
                    width: size.width,
                    color: Colors.white,
                  ));
            }
            if (snapshot.hasData) {
              return _ExampleWidget(
                examples: snapshot.data!,
                onComplete: widget.onComplete,
              );
            }
            return const LoadingSpinner();
          }),
    );
  }
}

class _ExampleWidget extends StatefulWidget {
  const _ExampleWidget({required this.examples, required this.onComplete});
  final List<Example> examples;
  final void Function() onComplete;

  @override
  State<_ExampleWidget> createState() => __ExampleWidgetState();
}

class __ExampleWidgetState extends State<_ExampleWidget> {
  int index = 0;

  late List<bool> understoodExamples;
  final WritingController _writingController = Get.find<WritingController>();

  @override
  void initState() {
    understoodExamples = List.generate(
        widget.examples.length, (index) => widget.examples[index].completed);

    _moveToExampleNotCompleted();
    super.initState();
  }

  void _moveToExampleNotCompleted() {
    for (int i = 0; i < widget.examples.length; i++) {
      if (!understoodExamples[i]) {
        setState(() {
          index = i;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: defaultPadding * 2, horizontal: defaultPadding),
          child: Builder(builder: (context) {
            Example example = widget.examples[index];
            return Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 5))
                      ],
                      borderRadius: BorderRadius.circular(20)),
                  child: TopicExampleCard(
                    example: example,
                    index: index,
                    onUnderstand: (example) {
                      Example example_ = widget.examples[index];
                      if (!example_.completed) {
                        _writingController.markExampleCompleted(example_);
                        Navigator.pop(context);
                      }
                      if (index == widget.examples.length - 1) {
                        Navigator.pop(context);
                        widget.onComplete();
                      }
                      setState(() {
                        understoodExamples[example] = true;
                        widget.examples[index].completed = true;
                      });
                    },
                  ),
                ),
              ],
            );
          }),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding * 2, vertical: defaultPadding),
          child: SizedBox(
            height: 70,
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: index != 0
                      ? TapBounce(
                          onTap: () {
                            if (index > 0) {
                              setState(() {
                                index--;
                              });
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.chevron_left,
                                size: 30,
                              ),
                              Text(
                                'Previous',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(
                          width: 40,
                        ),
                ),
                const Spacer(),
                Row(
                    children: List.generate(
                  widget.examples.length,
                  (index_) {
                    return AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: InkWell(
                        onTap: index_ == index
                            ? () {
                                if (!understoodExamples[index]) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const SessionErrorDialog(
                                        title: "Cannot Proceed",
                                        reason:
                                            "Please read the instructions before proceeding",
                                      );
                                    },
                                  );
                                } else {
                                  if (index < widget.examples.length - 1) {
                                    setState(() {
                                      index++;
                                    });
                                  } else if (index ==
                                      widget.examples.length - 1) {
                                    widget.onComplete();
                                  }
                                }
                              }
                            : null,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 4),
                          height: index_ == index ? 45 : 10,
                          width: index_ == index ? 45 : 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor),
                          child: index_ == index
                              ? AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: understoodExamples[index]
                                      ? index == widget.examples.length - 1
                                          ? const Icon(
                                              Icons.star_rounded,
                                              size: 30,
                                              color: Colors.white,
                                            )
                                          : const Icon(
                                              Icons.chevron_right_rounded,
                                              color: Colors.white,
                                              size: 30,
                                            )
                                      : const LoadingSpinner(
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ))
              ],
            ),
          ),
        )
      ],
    );
  }
}
