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
import 'package:word_and_learn/utils/ocr_utils.dart';

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
      child: Column(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                padding: allPadding,
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.surface),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Synonyms & Adjectives Exercise",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const Padding(
                          padding: allPadding,
                          child: CustomBackButton(),
                        ),
                      ],
                    ),
                    FutureBuilder<HttpResponse<Exercise>>(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: LoadingSpinner(),
                            );
                          } else if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData &&
                              snapshot.data!.isSuccess) {
                            return Expanded(
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
                            );
                          }
                          return const Text("Error UI element is here");
                        }),
                    const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.volume_up_rounded))
                  ],
                ),
              )),
          const Expanded(child: SubmissionProcessContainer()),
        ],
      ),
    ));
  }
}

class SubmissionProcessContainer extends StatefulWidget {
  const SubmissionProcessContainer({
    super.key,
  });

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

class SubmissionContainer extends StatelessWidget {
  const SubmissionContainer({
    super.key,
    this.submission,
  });

  final List<File>? submission;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Container(
          height: 70,
          decoration: BoxDecoration(
              color: submission != null && submission!.isNotEmpty
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (submission == null || submission!.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2),
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
                        "No exercise has been submitted",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2),
                  child: Row(
                    children: [
                      Image.file(
                        submission!.first,
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      SubmissionOCRWidget(
                        images: submission!,
                      )
                    ],
                  ),
                )
            ],
          )),
    );
  }
}

class SubmissionOCRWidget extends StatefulWidget {
  const SubmissionOCRWidget({super.key, required this.images});

  final List<File> images;

  @override
  State<SubmissionOCRWidget> createState() => _SubmissionOCRWidgetState();
}

class _SubmissionOCRWidgetState extends State<SubmissionOCRWidget> {
  Future<String?>? _future;
  @override
  void initState() {
    _future = OCRUtils.getTextFromImage(widget.images.first);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return const Text("WE HAVE THE TEXT!!");
          } else {
            return const Text("No data");
          }
        } else {
          return const Text("Loading...");
        }
      },
    );
  }
}
