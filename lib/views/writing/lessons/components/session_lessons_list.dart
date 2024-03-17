import 'package:flutter/material.dart';
import 'package:word_and_learn/components/loading_spinner.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/lessons/components/lesson_card.dart';
import 'package:word_and_learn/views/writing/lessons/lesson_detail_page.dart';

class SessionLessonsList extends StatefulWidget {
  const SessionLessonsList({
    super.key,
    required this.writingController,
    required this.size,
  });

  final WritingController writingController;
  final Size size;

  @override
  State<SessionLessonsList> createState() => _SessionLessonsListState();
}

class _SessionLessonsListState extends State<SessionLessonsList> {
  late Future<List<Lesson>> _future;

  @override
  void initState() {
    _future = widget.writingController.getCurrentSessionLessons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lesson>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSpinner();
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return SizedBox(
              height: 400,
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(width: defaultPadding * 2),
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Lesson lesson = snapshot.data![index];
                  return InkWell(
                    onTap: () {
                      if (lesson.unlocked) {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            builder: (context) {
                              return SizedBox(
                                  height: 600,
                                  width: widget.size.width,
                                  child: Padding(
                                    padding: allPadding,
                                    child: LessonDetailPage(lesson: lesson),
                                  ));
                            });
                      }
                    },
                    child: LessonCard(
                      lesson: lesson,
                    ),
                  );
                },
              ),
            );
          }
          return const Text("Error UI Element will come here");
        });
  }
}
