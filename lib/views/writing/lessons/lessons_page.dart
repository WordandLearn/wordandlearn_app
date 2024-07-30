import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/circle_profile_avatar.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/lessons/components/lesson_drawer.dart';
import 'components/composition_selector.dart';
import 'components/session_lessons_list.dart';
import 'components/session_report_card.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  WritingController writingController = Get.find<WritingController>();
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  void initState() {
    writingController.getCurrentSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _key,
        drawer: Drawer(
          width: 270,
          backgroundColor: Colors.white,
          child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding * 2, vertical: defaultPadding),
                child: LessonDrawer(
                  onClose: () {
                    _key.currentState!.closeDrawer();
                  },
                )),
          ),
        ),
        backgroundColor: const Color(0xFFF8F5FE),
        // padding: const EdgeInsets.symmetric(
        //     horizontal: defaultPadding, vertical: defaultPadding),
        // bottomNavigationBar: const AddCompositionButton(),
        appBar: AppBar(
            elevation: 0,
            toolbarHeight: 30,
            backgroundColor: Colors.transparent,
            title: Image.asset(
              "assets/logo/Logotype.png",
              width: 75,
            ),
            centerTitle: true,
            leading: Builder(builder: (context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: SvgPicture.asset(
                  "assets/icons/menu.svg",
                  width: 25,
                ),
              );
            }),
            actions: [
              InkWell(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: CircleProfileAvatar(
                    radius: 20,
                  ),
                ),
              ),
            ]),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              writingController.refetch();
            });
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              child: Column(children: [
                Obx(() {
                  if (writingController.userSessions.isEmpty) {
                    //TODO: Do some error handling when no session is available,guide on creating new session

                    return const Text("No Compositions, Add a new one");
                  }

                  if (writingController.currentUserSession.value == null) {
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: SizedBox(
                          height: size.height * 0.9,
                          child: const Center(child: LoadingSpinner())),
                    );
                  } else {
                    Session session =
                        writingController.currentUserSession.value!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: defaultPadding * 2),
                            child:
                                CompositionSelectorContainer(session: session),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Lessons",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              SessionLessonsList(
                                  writingController: writingController,
                                  size: size),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                }),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Obx(() {
                  Session? session = writingController.currentUserSession.value;

                  return SessionReportCard(
                    session: session,
                  );
                })
              ]),
            ),
          ),
        ));
  }
}
