import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/example.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/utils/timer.dart';
import 'package:word_and_learn/views/writing/topic/components/guide_text_dialog.dart';
import 'package:word_and_learn/views/writing/topic/components/topic_before_after.dart';
import 'package:word_and_learn/views/writing/topic/components/topic_success_dialog.dart';

Color beforeColor = const Color(0xFF82E7FE);

Color afterColor = const Color(0xFFFFE482);

class TopicExamplePage extends StatefulWidget {
  const TopicExamplePage(
      {super.key, required this.examples, required this.topic});
  final List<Example> examples;
  final Topic topic;

  @override
  State<TopicExamplePage> createState() => _TopicExamplePageState();
}

class _TopicExamplePageState extends State<TopicExamplePage> {
  bool isBefore = true;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.examples.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              SizedBox(
                height: size.height,
                width: size.width,
                child: Column(
                  children: [
                    Expanded(
                        child: TopicBeforeAfter(
                      example: widget.examples[index],
                      isBefore: true,
                    )),
                    Expanded(
                        child: TopicBeforeAfter(
                      example: widget.examples[index],
                      isBefore: false,
                    ))
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 2),
                child: _PageIndicators(
                    index: index, length: widget.examples.length),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: defaultPadding * 2, horizontal: defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (index == 0) {
                            Navigator.pop(context);
                          } else {
                            _pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.arrow_left_rounded,
                              size: 50,
                            ),
                            Text(
                              index == 0 ? "Back To Lesson" : "Previous",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: 100,
                          height: 35,
                          child: TimedWidget(
                            onCompleted: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return buildGuideTextDialog(context,
                                      widget.examples[index].guideText);
                                },
                              );
                            },
                            duration: TimerUtil.timeToRead(
                                widget.examples[index].beforeText +
                                    widget.examples[index].afterText),
                            child: CustomPrimaryButton(
                              text: index == widget.examples.length - 1
                                  ? "Finish"
                                  : "Next",
                              color: Theme.of(context).colorScheme.secondary,
                              onPressed: () {
                                if (index == widget.examples.length - 1) {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        buildtopicSuccessDialog(
                                            context, widget.topic),
                                  );
                                } else {
                                  _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeIn);
                                }
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ));
  }
}

class _PageIndicators extends StatelessWidget {
  const _PageIndicators({super.key, required this.index, required this.length});
  final int index;
  final int length;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: i == index ? 20 : 15,
              height: i == index ? 20 : 15,
              decoration: BoxDecoration(
                  color: i == index ? Colors.white : Colors.grey,
                  shape: BoxShape.circle),
            ),
          )
      ],
    );
  }
}
