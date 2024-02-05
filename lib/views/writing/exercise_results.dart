import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/lessons_page.dart';

class ExerciseResultsPage extends StatefulWidget {
  const ExerciseResultsPage(
      {super.key, required this.exerciseSubmission, required this.exercise});

  final ExerciseSubmission exerciseSubmission;
  final Exercise exercise;

  @override
  State<ExerciseResultsPage> createState() => _ExerciseResultsPageState();
}

class _ExerciseResultsPageState extends State<ExerciseResultsPage> {
  final WritingController writingController = WritingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScaffold(
        appBar: const Padding(
          padding: allPadding,
          child: Row(
            children: [CustomBackButton()],
          ),
        ),
        body: FutureBuilder<HttpResponse<ExerciseResult>>(
            future: writingController
                .getExerciseResults(widget.exerciseSubmission.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: LoadingSpinner(),
                );
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data!.isSuccess) {
                ExerciseResult exerciseResult = snapshot.data!.models.first;
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: size.height * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  exerciseResult.improvement
                                      ? "That was amazing!!!"
                                      : "Oh No! You can do better",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: exerciseResult.improvement
                                              ? Colors.green
                                              : Colors.red),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: defaultPadding),
                                  child: Text(
                                    exerciseResult.feedback,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(height: 1.5),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Our Recommendations",
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding),
                                child: Text(
                                  exerciseResult.recommendation,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomPrimaryButton(
                      text:
                          exerciseResult.improvement ? "Continue" : "Try Again",
                      // textColor: Theme.of(context).,
                      onPressed: () {
                        if (exerciseResult.improvement) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LessonsPage(),
                              ));
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      color: exerciseResult.improvement
                          ? Colors.green
                          : Colors.red,
                    )
                  ],
                );
              }
              return const Text("Error UI element");
            }));
  }
}
