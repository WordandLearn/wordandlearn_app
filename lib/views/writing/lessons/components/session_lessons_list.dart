import 'package:flutter/material.dart';
import 'package:word_and_learn/components/loading_spinner.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
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
    // Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<Lesson>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSpinner();
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return SizedBox(
              height: 400,
              child: GridView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: defaultPadding / 1.5,
                    mainAxisSpacing: defaultPadding / 1.5),
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding * 2,
                          horizontal: defaultPadding * 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding),
                            child: Text(
                              "${lesson.progress!.progress.toInt() * 100}% Complete",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          Stack(
                            children: [
                              Container(
                                height: 4,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: AppColors.blackContainerColor
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              Container(
                                height: 4,
                                width: 200 * lesson.progress!.progress,
                                decoration: BoxDecoration(
                                    color: lesson.color,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ],
                          )
                        ],
                      ),
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
