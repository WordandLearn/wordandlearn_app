import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/components/lesson_card.dart';
import 'package:word_and_learn/views/writing/lesson_detail_page.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  WritingController writingController = WritingController();
  late Future<HttpResponse<Lesson>> _future;
  @override
  void initState() {
    _future = WritingController().getSessionLessons(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScaffold(
        body: Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.arrow_back_ios),
                Text(
                  "A very sneaky day",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  width: 30,
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding * 2),
              child: MascotText(
                text: "Here are your lessons about your compositions",
                height: 100,
              ),
            )
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: FutureBuilder<HttpResponse<Lesson>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitRing(color: Theme.of(context).primaryColor),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data!.isSuccess) {
                    List<Lesson> lessons = snapshot.data!.models;
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: lessons.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: defaultPadding * 2,
                              mainAxisSpacing: defaultPadding * 2),
                      itemBuilder: (context, index) {
                        Lesson lesson = lessons[index];
                        return InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              builder: (context) {
                                return SizedBox(
                                  height: 600,
                                  width: size.width,
                                  child: Padding(
                                    padding: allPadding,
                                    child: LessonDetailPage(lesson: lesson),
                                  ),
                                );
                              },
                            );
                          },
                          child: LessonCard(
                            lesson: lesson,
                          ),
                        );
                      },
                    );
                  }
                  return const Text(
                      "UI element to show error will be placed here");
                }),
          ),
        )
      ],
    ));
  }
}
