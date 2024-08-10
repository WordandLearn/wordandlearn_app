import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_and_learn/components/circle_profile_avatar.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';
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
  late Future<List<Session>> userSessionsFuture;
  late Future<Session?> currentSessionFuture;
  @override
  void initState() {
    writingController.getCurrentSession();
    userSessionsFuture = writingController.fetchUserSessions();
    currentSessionFuture = writingController.fetchCurrentSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _key,
        drawerEnableOpenDragGesture: true,
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
                FutureBuilder<List<Session>>(
                    future: writingController.getUserSessions(),
                    builder: (context, snapshot) {
                      // if (snapshot.hasData && snapshot.data!.isEmpty) {
                      //   return const Text("No Colempositions, Add a new one");
                      // }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding),
                          child: SizedBox(
                              height: size.height * 0.9,
                              child: const Center(child: LoadingSpinner())),
                        );
                      } else {
                        return AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: defaultPadding * 2),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    child: Obx(() {
                                      if (writingController
                                              .currentUserSession.value ==
                                          null) {
                                        return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              height: 110,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ));
                                      }
                                      return CompositionSelectorContainer(
                                        session: writingController
                                            .currentUserSession.value!,
                                        userSessions:
                                            writingController.userSessions,
                                        onChanged: (session) async {
                                          await writingController
                                              .setCurrentSession(session);
                                          setState(() {
                                            currentSessionFuture =
                                                writingController
                                                    .fetchCurrentSession();
                                          });
                                        },
                                      );
                                    }),
                                  ),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    FutureBuilder<Session?>(
                                        future: writingController
                                            .fetchCurrentSession(),
                                        builder: (context, snapshot_) {
                                          return AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 600),
                                            child: Builder(
                                              builder: (context) {
                                                if (snapshot_.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const ShimmerSessionLessonsList();
                                                }
                                                if (snapshot_.hasError) {
                                                  return Text(snapshot_.error
                                                      .toString());
                                                }
                                                if (snapshot_.hasData) {
                                                  return SessionLessonsList(
                                                    currentSession:
                                                        snapshot_.data!,
                                                  );
                                                }
                                                return const ShimmerSessionLessonsList();
                                              },
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              )
                            ],
                          ),
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
