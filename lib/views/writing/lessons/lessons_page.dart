import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late Future<String> _futureName;
  @override
  void initState() {
    writingController.getCurrentSession();
    _futureName = getName();
    super.initState();
  }

  Future<String> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String name = preferences.getString("name") ?? "";
    if (name != "") {
      return name.split(" ")[0];
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScaffold(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding),
        bottomNavigationBar: const AddCompositionButton(),
        appBar: const ProfileAppBar(),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              writingController.refetch();
            });
          },
          child: ListView(children: [
            Column(
              children: [
                // CircleAvatar(
                //   backgroundImage: NetworkImage(defaultImageUrl),
                //   radius: 30,
                // ),
                // const SizedBox(
                //   height: defaultPadding * 2,
                // ),
                FutureBuilder<String>(
                    future: _futureName,
                    builder: (context, snapshot) {
                      return Text(
                        "Hello ${snapshot.data}",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.normal),
                      );
                    }),
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
                              return ListModalBottomSheet(
                                title: "Your Compositions",
                                items: writingController.userSessions,
                                onTap: (index) {
                                  setState(() {
                                    Session session_ =
                                        writingController.userSessions[index];
                                    writingController
                                        .setCurrentSession(session_);
                                  });
                                  Navigator.pop(context);
                                },
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
          ]),
        ));
  }
}
