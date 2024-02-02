import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/components/lesson_header_container.dart';

import 'components/topic_progress.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Row(
              children: [CustomBackButton()],
            ),
          ),
          LessonHeaderContainer(text: widget.lesson.title),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
            child: FutureBuilder<HttpResponse<Topic>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingSpinner();
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data!.isSuccess) {
                    List<Topic> topics = snapshot.data!.models;
                    return TopicProgress(topics: topics);
                  }
                  return const Text("UI element for error thing ");
                }),
          )
        ],
      ),
    ));
  }
}
