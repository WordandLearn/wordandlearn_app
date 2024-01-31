import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/example.dart';
import 'package:word_and_learn/utils/timer.dart';
import 'package:word_and_learn/views/writing/topic/components/topic_before_after.dart';

Color beforeColor = const Color(0xFF82E7FE);

Color afterColor = const Color(0xFFFFE482);

class TopicExamplePage extends StatefulWidget {
  const TopicExamplePage({super.key, required this.examples});
  final List<Example> examples;

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
      body: AnimatedContainer(
          padding: allPadding * 2,
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(color: isBefore ? beforeColor : afterColor),
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.examples.length,
            itemBuilder: (context, index) {
              Example example = widget.examples[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: _PageIndicators(
                          index: index,
                          isBefore: isBefore,
                          length: widget.examples.length),
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Expanded(
                      child: TopicBeforeAfter(
                        isBefore: isBefore,
                        example: example,
                        onBefore: () {
                          setState(() {
                            isBefore = true;
                          });
                        },
                        onAfter: () {
                          Future.delayed(
                              TimerUtil.timeToRead(example.afterText), () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => buildGuideTextDialog(
                                  context, example.guideText),
                            );
                          });

                          setState(() {
                            isBefore = false;
                          });
                        },
                        onNext: () {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);

                          setState(() {
                            isBefore = true;
                          });
                        },
                        onPrevious: () {
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}

Widget buildGuideTextDialog(BuildContext context, String guideText) {
  return Dialog(
    child: Container(
        height: 400,
        // padding: allPadding,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: allPadding,
              child: Container(
                  height: 330,
                  width: 300,
                  padding: allPadding * 2,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    guideText,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white),
                  )),
            ),
            const Positioned(bottom: -20, left: -30, child: Mascot(size: 130)),
            Positioned(
              bottom: defaultPadding * 2,
              right: defaultPadding * 2,
              child: TimedWidget(
                  child: SizedBox(
                    width: 130,
                    height: 30,
                    child: CustomPrimaryButton(
                      text: "I understand",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  duration: TimerUtil.timeToRead(guideText)),
            )
          ],
        )),
  );
}

class _PageIndicators extends StatelessWidget {
  const _PageIndicators(
      {super.key,
      required this.index,
      required this.isBefore,
      required this.length});
  final int index;
  final bool isBefore;
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
              width: i == index ? 25 : 20,
              height: i == index ? 25 : 20,
              decoration: BoxDecoration(
                  color: i == index
                      ? isBefore
                          ? Colors.white
                          : Colors.black
                      : Colors.grey,
                  shape: BoxShape.circle),
              child: i == index
                  ? Center(
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              color: isBefore
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).primaryColor,
                              shape: BoxShape.circle)),
                    )
                  : const SizedBox.shrink(),
            ),
          )
      ],
    );
  }
}
