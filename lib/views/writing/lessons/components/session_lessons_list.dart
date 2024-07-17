import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';

import 'lesson_card.dart';

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
            return const ShimmerSessionLessonsList();
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return SizedBox(
              height: 450,
              child: GridView.custom(
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverWovenGridDelegate.count(
                  crossAxisCount: 2,
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
                  );
                }, childCount: snapshot.data!.length),
              ),
            );
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
        child: GridView.custom(
            primary: false,
            gridDelegate: SliverWovenGridDelegate.count(
              crossAxisCount: 2,
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
            }, childCount: 4)));
  }
}
