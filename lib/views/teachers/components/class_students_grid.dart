import 'dart:developer';
import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/loading_spinner.dart';
import 'package:word_and_learn/components/teachers/teacher_student_card.dart';
import 'package:word_and_learn/components/teachers/teacher_upload_pending_modal.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/utils/file_utils.dart';
import 'package:word_and_learn/views/teachers/composition_edit_page.dart';

class ClassStudentsGrid extends StatefulWidget {
  const ClassStudentsGrid({
    super.key,
    this.studentFuture,
  });
  final Future<List<Profile>>? studentFuture;

  @override
  State<ClassStudentsGrid> createState() => _ClassStudentsGridState();
}

class _ClassStudentsGridState extends State<ClassStudentsGrid> {
  final TeacherController teacherController = Get.find<TeacherController>();
  @override
  void initState() {
    super.initState();
  }

  void captureDocuments(Profile student) async {
    try {
      final images = await CunningDocumentScanner.getPictures(
          noOfPages: 2, isGalleryImportAllowed: true);
      if (images != null) {
        List<File> files =
            images.map((path) => FileUtils.getFileFromPath(path)).toList();
        teacherController.compositionImages[student.id] = files;
        if (mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompositionEditPage(student: student),
              ));
        }
      }
    } on PlatformException {
      log("PLATFORM EXCEPTION OCCURED");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Profile>>(
        future: widget.studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null &&
              snapshot.data!.isEmpty) {
            return const Text("No students enrolled in the class");
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: defaultPadding,
                  mainAxisSpacing: defaultPadding),
              itemBuilder: (context, index) {
                Profile profile_ = snapshot.data![index];
                return GestureDetector(
                    onTap: () async {
                      List<File>? images =
                          teacherController.compositionImages[profile_.id];
                      if (images != null && images.isNotEmpty) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return TeacherUploadPendingModal(
                                images: images,
                                captureDocuments: () =>
                                    captureDocuments(profile_),
                                student: profile_);
                          },
                        );
                      } else {
                        captureDocuments(profile_);
                      }
                    },
                    child: TeacherStudentCard(profile: profile_));
              },
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("An error occured: ${snapshot.error}"));
          }
          return const Center(
            child: LoadingSpinner(),
          );
        });
  }
}
