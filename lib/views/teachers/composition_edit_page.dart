import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';

class CompositionEditPage extends StatefulWidget {
  const CompositionEditPage({super.key, required this.student});
  final Profile student;

  @override
  State<CompositionEditPage> createState() => _CompositionEditPageState();
}

class _CompositionEditPageState extends State<CompositionEditPage> {
  final TeacherController teacherController = Get.find<TeacherController>();
  int activeFile = 0;
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    List<File> images = teacherController.compositionImages[widget.student.id]!;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BackButton(
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Image.file(
                      images[activeFile],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding * 1.5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    widget.student.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int index = 0; index < images.length; index++)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  activeFile = index;
                                });
                              },
                              child: CompositionImageIndicator(
                                isActive: activeFile == index,
                                image: images[index],
                              ),
                            )
                        ],
                      )),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      isLoading: isUploading,
                      onPressed: () {
                        setState(() {
                          isUploading = true;
                        });
                        teacherController
                            .uploadCompositions(widget.student.id, images)
                            .then((value) {
                          if (value.isSuccess) {
                            teacherController.compositionImages
                                .remove(widget.student.id);
                            // show success dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Success"),
                                content: const Text(
                                    "Composition uploaded successfully"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"))
                                ],
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "An error has occured :(. Try again, or contact us",
                                style: TextStyle(color: Colors.red),
                              ),
                            ));
                          }
                        }).whenComplete(() {
                          setState(() {
                            isUploading = false;
                          });
                        });
                      },
                      color: Theme.of(context).primaryColor,
                      child: const Text(
                        "Confirm and Upload",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class CompositionImageIndicator extends StatelessWidget {
  const CompositionImageIndicator({
    super.key,
    this.isActive = false,
    required this.image,
  });
  final bool isActive;
  final File image;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1 : 0.8,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        decoration: BoxDecoration(
            border: Border.all(
                color: isActive ? Theme.of(context).primaryColor : Colors.grey,
                width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            image,
            width: 60,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
