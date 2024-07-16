import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/topic/components/topic_card.dart';
import 'package:word_and_learn/views/writing/topic/components/topic_tab_bar.dart';
import 'package:word_and_learn/views/writing/topic/topic_learn_page.dart';

class LessonTopicsPage extends StatefulWidget {
  const LessonTopicsPage({super.key, required this.lesson});
  final Lesson lesson;

  @override
  State<LessonTopicsPage> createState() => _LessonTopicsPageState();
}

class _LessonTopicsPageState extends State<LessonTopicsPage> {
  late Future<HttpResponse<Topic>> _future;
  final WritingController _writingController = WritingController();

  @override
  void initState() {
    _future = _writingController.getLessonTopics(widget.lesson.id);
    super.initState();
  }

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor:
            TinyColor.fromColor(widget.lesson.color!).lighten(40).color,
        body: SafeArea(
          child: SizedBox(
            height: size.height,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: const Center(
                                  child: Icon(
                                CupertinoIcons.back,
                                size: 25,
                              )),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: const Center(
                                child: Icon(
                              CupertinoIcons.heart,
                              size: 25,
                            )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding * 2),
                        child: Center(
                          child: Text(
                            widget.lesson.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: size.width,
                    height: size.height * 0.65,
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding * 2),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(40))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Column(
                        children: [
                          TopicTabBar(
                            onChanged: (index) {
                              setState(() {
                                activeIndex = index;
                              });
                            },
                            activeIndex: activeIndex,
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Expanded(
                              child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: activeIndex == 0
                                ? FutureBuilder<HttpResponse<Topic>>(
                                    future: _future,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const LoadingSpinner();
                                      }
                                      if (snapshot.hasError) {
                                        return const Text('Error');
                                      }
                                      return ListView.builder(
                                        itemCount: snapshot.data!.models.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: defaultPadding),
                                            child: TopicPageCard(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            TopicLearnPage(
                                                                topic: snapshot
                                                                        .data!
                                                                        .models[
                                                                    index]),
                                                      ));
                                                },
                                                topic: snapshot
                                                    .data!.models[index]),
                                          );
                                        },
                                      );
                                    })
                                : Text(
                                    widget.lesson.description,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                          ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
