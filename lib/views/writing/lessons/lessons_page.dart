import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';

import 'components/add_composition_button.dart';
import 'components/session_lessons_list.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  WritingController writingController = Get.find<WritingController>();

  @override
  void initState() {
    writingController.getCurrentSession();
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
          Obx(() {
            if (writingController.currentUserSession.value == null) {
              return const Text("No sessions loaded will come here");
            } else {
              Session session = writingController.currentUserSession.value!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding * 2),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: allPadding * 2,
                              decoration: BoxDecoration(
                                  color: AppColors.blackContainerColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Text(
                                    "Your Compositions",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                  Expanded(
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) {
                                        return Divider(
                                          color: Colors.white.withOpacity(0.4),
                                        );
                                      },
                                      itemCount:
                                          writingController.userSessions.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: defaultPadding),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                writingController
                                                    .setCurrentSession(
                                                        writingController
                                                                .userSessions[
                                                            index]);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              children: [
                                                Text((index + 1).toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color:
                                                                Colors.white)),
                                                const SizedBox(
                                                  width: defaultPadding * 2,
                                                ),
                                                Text(
                                                  writingController
                                                      .userSessions[index]
                                                      .titleOrDefault,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.blackContainerColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding,
                            horizontal: defaultPadding * 2),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Your current composition",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: AppColors.inactiveColor)),
                                const SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                Text(
                                  session.titleOrDefault,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding * 2),
                    child: SessionLessonsList(
                        writingController: writingController, size: size),
                  )
                ],
              );
            }
          })
        ]));
  }
}
