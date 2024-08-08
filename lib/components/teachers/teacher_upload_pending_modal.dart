import 'dart:io';

import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/teachers/composition_edit_page.dart';

class TeacherUploadPendingModal extends StatelessWidget {
  const TeacherUploadPendingModal(
      {super.key,
      required this.images,
      required this.captureDocuments,
      required this.student});
  final List<File> images;
  final Function() captureDocuments;
  final Profile student;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsetsDirectional.all(defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Some images are pending upload",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int index = 0; index < images.length; index++)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
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
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CompositionEditPage(student: student),
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
  }
}
