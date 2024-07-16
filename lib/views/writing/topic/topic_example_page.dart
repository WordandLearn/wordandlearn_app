import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/topic/components/topic_before_after.dart';

Color beforeColor = const Color(0xFF82E7FE);

Color afterColor = const Color(0xFFFFE482);

class TopicExamplePage extends StatefulWidget {
  const TopicExamplePage({super.key, required this.topic});
  final Topic topic;

  @override
  State<TopicExamplePage> createState() => _TopicExamplePageState();
}

class _TopicExamplePageState extends State<TopicExamplePage> {
  final PageController _pageController = PageController();
  final WritingController _writingController = WritingController();
  late Future<HttpResponse<Example>> _future;

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
        body: SafeArea(
      child: FutureBuilder<HttpResponse<Example>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingSpinner();
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data!.isSuccess) {
              List<Example> examples = snapshot.data!.models;

              return SwipeDetector(
                onSwipeRight: (offset) {
                  _pageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                  if (index != 0) {
                    setState(() {
                      index--;
                    });
                  }
                },
                onSwipeLeft: (offset) {
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                  if (index < examples.length) {
                    setState(() {
                      index++;
                    });
                  }
                },
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: examples.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: size.height,
                          width: size.width,
                          child: Column(
                            children: [
                              Expanded(
                                  child: TopicBeforeAfter(
                                example: examples[index],
                                isBefore: true,
                              )),
                              Expanded(
                                  child: TopicBeforeAfter(
                                example: examples[index],
                                isBefore: false,
                              ))
                            ],
                          ),
                        );
                      },
                    ),
                    _PageIndicators(index: index, length: examples.length),
                  ],
                ),
              );
            }
            return const Text("UI thing when there is an error");
          }),
    ));
  }
}

class _PageIndicators extends StatelessWidget {
  const _PageIndicators({required this.index, required this.length});
  final int index;
  final int length;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          height: 4,
          decoration: BoxDecoration(color: Colors.white),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: size.width * (index + 1) / length,
          height: 4,
          decoration: BoxDecoration(color: AppColors.secondaryColor),
        ),
      ],
    );
  }
}
