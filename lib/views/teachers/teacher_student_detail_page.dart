import 'dart:developer';
import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/teachers/teacher_upload_pending_modal.dart';
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
                return TeacherUploadPendingModal(
                    images: images,
                    captureDocuments: captureDocuments,
                    student: widget.student);
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
