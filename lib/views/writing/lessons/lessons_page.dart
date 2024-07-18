import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
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
    return Scaffold(
        key: _key,
        drawer: const Drawer(),
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
            leading: GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                "assets/icons/menu.svg",
                width: 25,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(defaultImageUrl),
                    radius: 15,
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
                  if (writingController.currentUserSession.value == null) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: defaultPadding),
                      //TODO: Do some error handling when no session is available
                      child: SizedBox(
                          height: size.height * 0.9,
                          child: Text("No sessions loaded will come here")),
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
