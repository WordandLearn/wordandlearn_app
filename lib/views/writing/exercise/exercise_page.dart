import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/components/fade_indexed_stack.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/exercise/components/exercise_action_button.dart';

import 'components/exercise_appbar.dart';
import 'exercise_details_page.dart';
import 'exercise_submission_page.dart';

class ExercisePage extends StatefulWidget {
  final Topic topic;
  const ExercisePage({super.key, required this.topic});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  late Future<HttpResponse<Exercise>> _future;
  final WritingController writingController = WritingController();

  @override
  void initState() {
    _future = writingController.getTopicExercise(widget.topic.id);
    super.initState();
  }

  double progress = 1 / 3;
  int currentPage = 0;
  bool isUploading = false;
  List<String?>? submissionImagePaths = [];

  void _selectImages() async {
    List<String?>? imagePaths = await CunningDocumentScanner.getPictures(
        isGalleryImportAllowed: true, noOfPages: 1);
    if (imagePaths != null) {
      setState(() {
        submissionImagePaths = imagePaths;
        if (currentPage == 0) {
          currentPage++;
        }
      });
    }
  }

  void _submitExercise(Exercise exercise) async {
    setState(() {
      isUploading = true;
    });
    List<File> images = submissionImagePaths!.map((e) => File(e!)).toList();
    HttpResponse<ExerciseSubmission> response =
        await writingController.uploadExercise(exercise.id, images);
    if (response.isSuccess) {
      setState(() {
        isUploading = false;
        currentPage++;
      });
    } else {
      setState(() {
        isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Could not upload submission. ${response.data}")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.secondaryContainer,
      body: SafeArea(
          child: FutureBuilder<HttpResponse<Exercise>>(
              future: _future,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    ExerciseAppbar(
                      topic: widget.topic,
                      progress: (currentPage + 1) / 3,
                      onBack: () {
                        if (currentPage == 0) {
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            currentPage--;
                          });
                        }
                      },
                    ),
                    Expanded(
                      child: FadeIndexedStack(
                        duration: const Duration(milliseconds: 300),
                        index: currentPage,
                        children: [
                          ExerciseDetailsPage(
                            snapshot: snapshot,
                            topic: widget.topic,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding,
                                horizontal: defaultPadding),
                            child: ExerciseSubmissionPage(
                              imagePaths: submissionImagePaths,
                            ),
                          ),
                          const Scaffold(
                            body: Center(
                              child: Text("Exercise Submission Page"),
                            ),
                          )
                        ],
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      child: Container(
                        height: snapshot.hasData && snapshot.data!.isSuccess
                            ? 100
                            : 50,
                        width: size.width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: defaultPadding),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Write your answer on paper"),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              snapshot.hasData && snapshot.data!.isSuccess
                                  ? Builder(builder: (context) {
                                      return ExerciseActionButton(
                                        currentPage: currentPage,
                                        selectImages: _selectImages,
                                        uploading: isUploading,
                                        onContinue: () {
                                          if (currentPage == 0) {
                                            _selectImages();
                                            setState(() {
                                              currentPage++;
                                            });
                                          } else {
                                            // submit exercise
                                            _submitExercise(
                                                snapshot.data!.models.first);
                                          }
                                        },
                                      );
                                    })
                                  : const LoadingSpinner(),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              })),
    );
  }
}
