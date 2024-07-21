import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/models/models.dart';

import 'components/exercise_appbar.dart';

class ExerciseResultsPage extends StatefulWidget {
  const ExerciseResultsPage({
    super.key,
    required this.exerciseSubmission,
    required this.topic,
    required this.exercise,
  });

  final ExerciseSubmission? exerciseSubmission;
  final Topic topic;
  final Exercise exercise;

  @override
  State<ExerciseResultsPage> createState() => _ExerciseResultsPageState();
}

class _ExerciseResultsPageState extends State<ExerciseResultsPage> {
  final WritingController writingController = WritingController();
  late Future<HttpResponse<ExerciseResult>> _future;
  @override
  void initState() {
    _future =
        writingController.getExerciseResults(widget.exerciseSubmission!.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ExerciseAppbar(
              topic: widget.topic,
              progress: 3 / 3,
              onBack: () {
                Navigator.pop(context);
              },
            ),
            FutureBuilder<HttpResponse<ExerciseResult>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  ExerciseResult? result = snapshot.data?.models.first;
                  return Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            result != null
                                ? Positioned(
                                    top: -50,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          result.success
                                              ? "assets/stickers/cat_happy.png"
                                              : "assets/stickers/duck_sad.png",
                                          height: 80,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: defaultPadding * 2,
                                              left: defaultPadding / 2),
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal:
                                                          defaultPadding,
                                                      vertical: defaultPadding),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Text(
                                                result.message,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                              )),
                                        )
                                      ],
                                    ))
                                : const SizedBox.shrink(),
                            result != null
                                ? Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding,
                                        vertical: defaultPadding),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding * 2,
                                        vertical: defaultPadding * 2),
                                    decoration: BoxDecoration(
                                        color: result.success
                                            ? AppColors.greenColor
                                            : AppColors.redColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      result.feedback,
                                      style: const TextStyle(
                                          fontSize: 18, height: 1.5),
                                    ),
                                  )
                                : Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: defaultPadding,
                                          vertical: defaultPadding),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: defaultPadding * 2,
                                          vertical: defaultPadding * 2),
                                      decoration: BoxDecoration(
                                          color: AppColors.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    )),
                          ],
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: size.width,
                            margin: const EdgeInsets.symmetric(
                                horizontal: defaultPadding * 2,
                                vertical: defaultPadding * 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding / 2,
                                vertical: defaultPadding / 2),
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(40)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: defaultPadding * 2,
                                      vertical: defaultPadding),
                                  child: Text(
                                    "Our Recommendation",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding / 2,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding,
                                      vertical: defaultPadding),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: result == null
                                        ? const LoadingSpinner()
                                        : Builder(builder: (context) {
                                            return Text(
                                              result.recommendation.isEmpty
                                                  ? "No recommendation from us"
                                                  : result.recommendation,
                                              style: const TextStyle(height: 2),
                                            );
                                          }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        result != null
                            ? TapBounce(
                                onTap: () {
                                  if (!result.success) {
                                    Navigator.pop(context);
                                  } else {
                                    writingController
                                        .markExerciseCompleted(widget.exercise);
                                    setState(() {
                                      widget.exercise.completed = true;
                                    });
                                    //Navigate to topic page using push and remove until
                                    Navigator.popUntil(
                                        context,
                                        (route) =>
                                            route.settings.name ==
                                            "LessonTopicsPage");
                                  }
                                },
                                child: PrimaryButton(
                                    color: result.success
                                        ? AppColors.greenColor
                                        : AppColors.redColor,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(result.success
                                            ? "Finish Topic"
                                            : "Retry Exercise"),
                                        const SizedBox(
                                          width: defaultPadding / 2,
                                        ),
                                        Icon(result.success
                                            ? Icons.star_rounded
                                            : CupertinoIcons.refresh)
                                      ],
                                    )),
                              )
                            : const SizedBox(
                                height: 50,
                              )
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
