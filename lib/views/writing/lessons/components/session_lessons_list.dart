import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';

import 'lesson_card.dart';

class SessionLessonsList extends StatefulWidget {
  const SessionLessonsList({
    super.key,
    required this.currentSession,
  });

  final Session? currentSession;

  @override
  State<SessionLessonsList> createState() => _SessionLessonsListState();
}

class _SessionLessonsListState extends State<SessionLessonsList> {
  late Future<List<Lesson>?> _future;
  final WritingController writingController = Get.find<WritingController>();
  @override
  void initState() {
    _future = writingController.getSessionLessons(widget.currentSession!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<Lesson>?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ShimmerSessionLessonsList();
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return LayoutBuilder(builder: (context, constraints) {
              return GridView.custom(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverWovenGridDelegate.count(
                  crossAxisCount: constraints.maxWidth < 768
                      ? 2
                      : constraints.maxWidth > 1100
                          ? 4
                          : 3,
                  mainAxisSpacing: defaultPadding / 2,
                  crossAxisSpacing: defaultPadding / 2,
                  pattern: [
                    const WovenGridTile(1),
                    const WovenGridTile(
                      5 / 7,
                      crossAxisRatio: 0.9,
                      // alignment: AlignmentDirectional.centerEnd,
                    ),
                  ],
                ),
                childrenDelegate: SliverChildBuilderDelegate((context, index) {
                  return LessonCard(
                    lesson: snapshot.data![index],
                    isAvaliable: index == 0
                        ? true
                        : snapshot.data![index - 1].isCompleted,
                  );
                }, childCount: snapshot.data!.length),
              );
            });
          }
          return const Text("Error UI Element will come here");
        });
  }
}

class ShimmerSessionLessonsList extends StatelessWidget {
  const ShimmerSessionLessonsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 450,
        child: LayoutBuilder(builder: (context, constraints) {
          return GridView.custom(
              primary: false,
              gridDelegate: SliverWovenGridDelegate.count(
                crossAxisCount: constraints.maxWidth < 768
                    ? 2
                    : constraints.maxWidth > 1100
                        ? 4
                        : 3,
                mainAxisSpacing: defaultPadding / 2,
                crossAxisSpacing: defaultPadding / 2,
                pattern: [
                  const WovenGridTile(1),
                  const WovenGridTile(
                    5 / 7,
                    crossAxisRatio: 0.9,
                    // alignment: AlignmentDirectional.centerEnd,
                  ),
                ],
              ),
              childrenDelegate: SliverChildBuilderDelegate((context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white)),
                );
              }, childCount: 4));
        }));
  }
}
