import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/teachers/components/class_students_grid.dart';

class TeacherClassesPage extends StatefulWidget {
  const TeacherClassesPage({super.key});

  @override
  State<TeacherClassesPage> createState() => _TeacherClassesPageState();
}

class _TeacherClassesPageState extends State<TeacherClassesPage> {
  final TeacherController teacherController = Get.find<TeacherController>();

  int selectedClass = 0;
  Future<List<Profile>>? _studentFuture;
  @override
  void initState() {
    _studentFuture = teacherController
        .getClassStudents(teacherController.classes[selectedClass].id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: defaultPadding, horizontal: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ProfileAppBar(),
            SizedBox(
              height: size.height * 0.03,
            ),
            Column(
              children: [
                Obx(() {
                  return Text(
                    "Hello  ${teacherController.profile.value != null ? teacherController.profile.value!.firstName : "Teacher"}",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.normal),
                  );
                }),
                Text(
                  "Let's Continue",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 26),
                )
              ],
            ),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: teacherController.classes.isEmpty
                    ? const Center(
                        child: LoadingSpinner(),
                      )
                    : InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return ListModalBottomSheet(
                                  title: "Your Classes",
                                  items: teacherController.classes
                                      .map((e) => e.className)
                                      .toList(),
                                  onTap: (index) {
                                    setState(() {
                                      selectedClass = index;
                                      _studentFuture = teacherController
                                          .getClassStudents(teacherController
                                              .classes[index].id);
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              });
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
                                  Text("Your classes",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: AppColors.inactiveColor)),
                                  const SizedBox(
                                    height: defaultPadding / 2,
                                  ),
                                  Text(
                                    teacherController.classes.isEmpty
                                        ? "Getting your classes..."
                                        : teacherController
                                            .classes[selectedClass].className,
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
              );
            }),
            Expanded(
                child: Obx(() => teacherController.classes.isEmpty
                    ? const LoadingSpinner()
                    : ClassStudentsGrid(
                        studentFuture: _studentFuture,
                      )))
          ],
        ));
  }
}