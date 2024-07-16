import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'components/composition_selector.dart';
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
        backgroundColor: Color(0xFFF8F5FE),
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding),
        // bottomNavigationBar: const AddCompositionButton(),
        appBar: const ProfileAppBar(),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              writingController.refetch();
            });
          },
          child: SingleChildScrollView(
            child: Column(children: [
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
                            vertical: defaultPadding),
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
                          child: CompositionSelectorContainer(session: session),
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
              })
            ]),
          ),
        ));
  }
}
