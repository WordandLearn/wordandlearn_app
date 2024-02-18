import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/utils/file_utils.dart';

import 'exercise_results.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key, required this.topic});
  final Topic topic;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder<HttpResponse<Exercise>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingSpinner(),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data!.isSuccess) {
              return Column(
                children: [
                  Expanded(
                      flex: 3,
                      child: Container(
                        padding: allPadding,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    widget.topic.title,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                                const Padding(
                                  padding: allPadding,
                                  child: CustomBackButton(),
                                ),
                              ],
                            ),
                            Expanded(
                              child: AutoSizeText(
                                snapshot.data!.models.first.description,
                                textAlign: TextAlign.center,
                                maxFontSize: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .fontSize!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        height: 2, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.volume_up_rounded))
                          ],
                        ),
                      )),
                  Expanded(
                      child: SubmissionProcessContainer(
                    exercise: snapshot.data!.models.first,
                  )),
                ],
              );
            }
            return Text("Error UI element is here ${snapshot.error}");
          }),
    ));
  }
}

class SubmissionProcessContainer extends StatefulWidget {
  const SubmissionProcessContainer({
    super.key,
    required this.exercise,
  });
  final Exercise exercise;

  @override
  State<SubmissionProcessContainer> createState() =>
      _SubmissionProcessContainerState();
}

class _SubmissionProcessContainerState
    extends State<SubmissionProcessContainer> {
  List<File>? files;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: allPadding,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Your Submission",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          SubmissionContainer(
            submission: files,
            exercise: widget.exercise,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Upload Your Submission",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Icon(Icons.arrow_right_alt),
              ),
              RoundIconButton(
                  onPressed: () async {
                    try {
                      final images =
                          await CunningDocumentScanner.getPictures(true);
                      if (images != null) {
                        List<File> files = images
                            .map((path) => FileUtils.getFileFromPath(path))
                            .toList();

                        setState(() {
                          this.files = files;
                        });
                      }
                    } on PlatformException {
                      log("A PLATFORM EXCEPTION");
                    }
                  },
                  icon: const Icon(
                    Icons.document_scanner,
                    color: Colors.black,
                  ))
            ],
          )
        ],
      ),
    );
  }
}

class SubmissionContainer extends StatefulWidget {
  const SubmissionContainer(
      {super.key, this.submission, required this.exercise});

  @override
  State<SubmissionContainer> createState() => _SubmissionContainerState();

  final List<File>? submission;

  final Exercise exercise;
}

class _SubmissionContainerState extends State<SubmissionContainer> {
  final WritingController writingController = WritingController();
  HttpResponse<ExerciseSubmission>? exerciseSubmission;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (widget.submission == null || widget.submission!.isEmpty) {
        return Container(
          height: 70,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/document.svg",
                  height: 30,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Text(
                  "No exercise has been submitted. Upload to continue",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),
        );
      }
      if (widget.submission != null &&
          widget.submission!.isNotEmpty &&
          exerciseSubmission == null) {
        return _SubmissionUploadingContainer(
          exercise: widget.exercise,
          submission: widget.submission!,
        );
      }
      return const Text("Exercise Submission Container");
    });
  }
}

class _SubmissionUploadingContainer extends StatefulWidget {
  const _SubmissionUploadingContainer({
    required this.exercise,
    required this.submission,
  });

  final Exercise exercise;
  final List<File> submission;
  // final ExerciseSubmission? exerciseSubmission;

  @override
  State<_SubmissionUploadingContainer> createState() =>
      _SubmissionUploadingContainerState();
}

class _SubmissionUploadingContainerState
    extends State<_SubmissionUploadingContainer> {
  final WritingController writingController = WritingController();
  late Future<HttpResponse<ExerciseSubmission>> _future;
  @override
  void initState() {
    _future =
        writingController.uploadExercise(widget.exercise.id, widget.submission);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 70,
          decoration: BoxDecoration(
              color: snapshot.connectionState == ConnectionState.waiting
                  ? AppColors.containerColor
                  : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
            child: Row(
              children: [
                Image.file(
                  widget.submission.first,
                  height: 50,
                  width: 50,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Builder(
                  builder: (context) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Expanded(
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(20),
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.white),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data!.isSuccess) {
                        ExerciseSubmission submission =
                            snapshot.data!.models.first;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExerciseResultsPage(
                                          exercise: widget.exercise,
                                          exerciseSubmission: submission,
                                        )));
                          },
                          child: Row(
                            children: [
                              Text(
                                "Uploaded.",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: defaultPadding * 2,
                              ),
                              Text("Tap To View Results",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w600))
                            ],
                          ),
                        );
                      }
                    }

                    return const Text("Error uploading");
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// class SubmissionContainer extends StatelessWidget {
//   const SubmissionContainer({
//     super.key,
//     this.submission,
//     required this.exercise, this.exerciseSubmission,
//   });

//   final List<File>? submission;
//   final Exercise exercise;
//   final ExerciseSubmission? exerciseSubmission;

//   @override
//   Widget build(BuildContext context) {
//     return Opacity(
//       opacity: 0.8,
//       child: Container(
//           height: 70,
//           decoration: BoxDecoration(
//               color: submission != null && submission!.isNotEmpty
//                   ? Theme.of(context).primaryColor
//                   : Colors.grey,
//               borderRadius: BorderRadius.circular(10)),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (submission == null || submission!.isEmpty)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: defaultPadding * 2),
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(
//                         "assets/icons/document.svg",
//                         height: 30,
//                       ),
//                       const SizedBox(
//                         width: defaultPadding,
//                       ),
//                       Text(
//                         "No exercise has been submitted",
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       )
//                     ],
//                   ),
//                 )
//               else
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: defaultPadding * 2),
//                   child: Row(
//                     children: [
//                       Image.file(
//                         submission!.first,
//                         height: 50,
//                         width: 50,
//                       ),
//                       const SizedBox(
//                         width: defaultPadding,
//                       ),
//                       SubmissionOCRWidget(
//                         images: submission!,
//                         exercise: exercise,
//                       )
//                     ],
//                   ),
//                 )
//             ],
//           )),
//     );
//   }
// }

// class SubmissionOCRWidget extends StatefulWidget {
//   const SubmissionOCRWidget(
//       {super.key, required this.images, required this.exercise});

//   final List<File> images;
//   final Exercise exercise;

//   @override
//   State<SubmissionOCRWidget> createState() => _SubmissionOCRWidgetState();
// }

// class _SubmissionOCRWidgetState extends State<SubmissionOCRWidget> {
//   final WritingController _writingController = WritingController();

//   @override
//   void initState() {
//     _writingController.uploadExercise(widget.exercise.id, widget.images);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text("Uploading");
//   }
// }
