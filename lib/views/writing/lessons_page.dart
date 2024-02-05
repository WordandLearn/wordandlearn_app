import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/components/add_composition_button.dart';
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
    _future = WritingController().getSessionLessons(2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScaffold(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding),
        bottomNavigationBar: const AddCompositionButton(),
        appBar: const ProfileAppBar(),
        body: ListView(children: [
          Column(
            children: [
              // CircleAvatar(
              //   backgroundImage: NetworkImage(defaultImageUrl),
              //   radius: 30,
              // ),
              // const SizedBox(
              //   height: defaultPadding * 2,
              // ),
              Text(
                "Hello Arabella.",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              Text(
                "Where were we?",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 30),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.blackContainerColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(
                      vertical: defaultPadding, horizontal: defaultPadding * 2),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your current composition",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: AppColors.inactiveColor)),
                          const SizedBox(
                            height: defaultPadding / 2,
                          ),
                          Text(
                            "The Big Mascular Man",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white),
                          )
                        ],
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        "assets/icons/exchange.svg",
                        color: Colors.white,
                        width: 25,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 2),
                child: FutureBuilder<HttpResponse<Lesson>>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingSpinner();
                      } else if (snapshot.connectionState ==
                              ConnectionState.done &&
                          snapshot.hasData &&
                          snapshot.data!.isSuccess) {
                        return SizedBox(
                          height: 400,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: defaultPadding * 2),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.models.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Lesson lesson = snapshot.data!.models[index];
                              return InkWell(
                                onTap: () {
                                  if (lesson.unlocked) {
                                    showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.white,
                                        builder: (context) {
                                          return SizedBox(
                                              height: 600,
                                              width: size.width,
                                              child: Padding(
                                                padding: allPadding,
                                                child: LessonDetailPage(
                                                    lesson: lesson),
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
                    }),
              )
            ],
          )
        ]));
  }
}
