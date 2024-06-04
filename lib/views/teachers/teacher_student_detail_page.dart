import 'dart:developer';
import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/utils/file_utils.dart';
import 'package:word_and_learn/views/teachers/composition_edit_page.dart';
import 'package:word_and_learn/views/writing/lessons/components/add_composition_button.dart';

class TeacherStudentDetailPage extends StatefulWidget {
  const TeacherStudentDetailPage({super.key, required this.student});
  final Profile student;

  @override
  State<TeacherStudentDetailPage> createState() =>
      _TeacherStudentDetailPageState();
}

class _TeacherStudentDetailPageState extends State<TeacherStudentDetailPage> {
  final TeacherController teacherController = Get.find<TeacherController>();

  void captureDocuments() async {
    try {
      final images = await CunningDocumentScanner.getPictures(
          noOfPages: 2, isGalleryImportAllowed: true);
      if (images != null) {
        List<File> files =
            images.map((path) => FileUtils.getFileFromPath(path)).toList();
        teacherController.compositionImages[widget.student.id] = files;
        if (context.mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CompositionEditPage(student: widget.student),
              ));
        }
      }
    } on PlatformException {
      log("PLATFORM EXCEPTION OCCURED");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: AddCompositionButton(
        onPressed: () async {
          List<File>? images =
              teacherController.compositionImages[widget.student.id];
          if (images != null && images.isNotEmpty) {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  padding: EdgeInsetsDirectional.all(defaultPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Some images are pending upload",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int index = 0; index < images.length; index++)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding),
                                child: Image.file(
                                  images[index],
                                  width: 50,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              captureDocuments();
                            },
                            child: const Text(
                              "Take New",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CompositionEditPage(
                                        student: widget.student),
                                  ));
                            },
                            child: const Text(
                              "Proceed To Upload",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            captureDocuments();
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                Text(
                  widget.student.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  width: 50,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
