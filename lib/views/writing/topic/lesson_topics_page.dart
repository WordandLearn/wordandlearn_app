import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/writing/topic/components/topic_card.dart';

class LessonTopicsPage extends StatefulWidget {
  const LessonTopicsPage({super.key, required this.lesson});
  final Lesson lesson;

  @override
  State<LessonTopicsPage> createState() => _LessonTopicsPageState();
}

class _LessonTopicsPageState extends State<LessonTopicsPage> {
  late Future<List<Topic>?> _future;
  final WritingController _writingController = WritingController();

  @override
  void initState() {
    _future = _writingController.getLessonTopics(widget.lesson.id);
    super.initState();
  }

  int activeIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.87);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:
          TinyColor.fromColor(widget.lesson.color!).darken(10).color,
      body: SafeArea(
          child: FutureBuilder<List<Topic>?>(
              future: _future,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2, vertical: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          offset: const Offset(0, 2),
                                          blurRadius: 5)
                                    ]),
                                child: const Icon(
                                  Icons.chevron_left,
                                  size: 35,
                                )),
                          ),
                          widget.lesson.progress != null
                              ? CircularPercentIndicator(
                                  radius: 15,
                                  percent: widget.lesson.progress!.progress,
                                  progressColor: widget.lesson.color,
                                  backgroundColor: Colors.white,
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding * 2),
                        child: SizedBox(
                          height: 70,
                          child: snapshot.hasData && snapshot.data!.isNotEmpty
                              ? Builder(builder: (context) {
                                  Topic topic = snapshot.data![activeIndex];
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    switchInCurve: Curves.easeOut,
                                    child: Column(
                                      key: ValueKey<int>(activeIndex),
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          topic.tag,
                                          key: ValueKey<int>(activeIndex),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: defaultPadding / 4,
                                        ),
                                        AutoSizeText(
                                          topic.title,
                                          key: ValueKey<String>(topic.title),
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  );
                                })
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: (size.height * 0.6) + 20,
                        child: Builder(builder: (context) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LoadingSpinner();
                          } else if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            List<Topic> topics = snapshot.data!;
                            return PageView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                controller: _pageController,
                                itemCount: topics.length,
                                onPageChanged: (value) {
                                  setState(() {
                                    activeIndex = value;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  Topic topic = topics[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding),
                                    child: LessonTopicCard(
                                      topic: topic,
                                      lesson: widget.lesson,
                                      isAvailable: index == 0 ||
                                          topics[index - 1].completed,
                                    ),
                                  );
                                });
                          }
                          return const LoadingSpinner();
                        }),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding * 2),
                        child: Builder(builder: (context) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          } else if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            List<Topic> topics = snapshot.data!;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                topics.length,
                                (index) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: 5,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding / 4),
                                    width: index == activeIndex ? 30 : 5,
                                    decoration: BoxDecoration(
                                        color: index == activeIndex
                                            ? Colors.white
                                            : Colors.white60,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  );
                                },
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      )
                    ],
                  ),
                );
              })),
    );
  }
}
