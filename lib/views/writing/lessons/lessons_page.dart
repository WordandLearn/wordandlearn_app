import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/circle_profile_avatar.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/utils/exceptions.dart';
import 'package:word_and_learn/views/writing/lessons/components/lesson_drawer.dart';
import 'package:word_and_learn/views/writing/lessons/components/lesson_empty_state.dart';
import 'package:word_and_learn/views/writing/lessons/components/lesson_error_page.dart';
import 'package:word_and_learn/views/writing/settings/profile/change_picture_page.dart';
import 'package:word_and_learn/views/writing/settings/subscription_settings.dart';
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
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return const SizedBox(
                            height: 500, child: ChangePicturePage());
                      });
                },
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
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding),
                  child: Column(children: [
                    FutureBuilder<List<Session>?>(
                        future: writingController.getUserSessions(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.isEmpty) {
                            return SizedBox(
                              height: size.height * 0.8,
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: defaultPadding,
                                      vertical: defaultPadding),
                                  child: LessonEmptyState(),
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return LayoutBuilder(
                                builder: (context, constraints) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding),
                                child: Center(
                                  child: SizedBox(
                                      height: size.height * 0.9,
                                      width: constraints.maxWidth > 600
                                          ? 600
                                          : constraints.maxWidth,
                                      child: Center(
                                          child: Builder(builder: (context) {
                                        if (snapshot.error
                                            is HttpFetchException) {
                                          HttpFetchException exception =
                                              snapshot.error
                                                  as HttpFetchException;
                                          if (exception.statusCode == 402) {
                                            return LessonErrorPage(
                                              assetUrl:
                                                  "assets/illustrations/penguin_holding_card.png",
                                              errorTitle:
                                                  "Subscription or Trial Required",
                                              errorText:
                                                  "You need to subscribe or start a free trial to use WordandLearn",
                                              action: TapBounce(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return const SubscriptionSettings();
                                                  }));
                                                },
                                                child: const PrimaryIconButton(
                                                    text:
                                                        "Go To Subscription Settings",
                                                    icon: Icon(
                                                      CupertinoIcons
                                                          .chevron_right,
                                                      size: 17,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            );
                                          }
                                        }
                                        return LessonErrorPage(
                                          errorTitle: "An error has occured",
                                          assetUrl:
                                              "assets/illustrations/penguin_holding_error.png",
                                          errorText:
                                              "There was an error fetching your lessons. Please try again later",
                                          action: TapBounce(
                                            onTap: () {
                                              setState(() {
                                                writingController.refetch();
                                              });
                                            },
                                            child: const PrimaryIconButton(
                                                text: "Try Again",
                                                icon: Icon(
                                                  CupertinoIcons.refresh,
                                                  size: 17,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        );
                                      }))),
                                ),
                              );
                            });
                          }
                          //
                          if (!snapshot.hasData) {
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
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: Obx(() {
                                          if (writingController
                                                  .currentSession ==
                                              null) {
                                            return Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
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
                                            },
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                  _LessonsList(
                                    currentSessionFuture:
                                        writingController.fetchCurrentSession(),
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
                      Session? session =
                          writingController.currentUserSession.value;

                      return session == null
                          ? const SizedBox.shrink()
                          : SessionReportCard(
                              session: session,
                            );
                    })
                  ]),
                ),
              ),
              writingController.subscriptionStatus ==
                      SubscriptionStatus.trialActive
                  ? Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const SubscriptionSettings();
                            }));
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding,
                                  vertical: defaultPadding / 2),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.7),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("You are on the free trial",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ],
                              )),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ));
  }
}

class _LessonsList extends StatefulWidget {
  const _LessonsList({required this.currentSessionFuture});

  final Future<Session?> currentSessionFuture;
  @override
  State<_LessonsList> createState() => __LessonsListState();
}

class __LessonsListState extends State<_LessonsList> {
  @override
  void initState() {
    super.initState();
  }

  final WritingController writingController = Get.find<WritingController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: Builder(
              builder: (context) {
                return Obx(
                  () {
                    Session? session =
                        writingController.currentUserSession.value;
                    if (session == null) {
                      return const ShimmerSessionLessonsList();
                    } else {
                      return SessionLessonsList(
                        currentSession: session,
                      );
                    }
                  },
                  key: ValueKey<int?>(
                      writingController.currentUserSession.value?.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
