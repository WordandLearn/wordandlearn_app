import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/models/models.dart';

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
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.chevron_left,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(
                                width: defaultPadding,
                              ),
                              Text(
                                widget.topic.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.7,
                            child: Container(
                              width: size.width,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: widget.topic.darkerColor),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Builder(builder: (context) {
                        //TODO: Handle httpresponse error
                        return SingleChildScrollView(
                          child: Container(
                            height: size.height,
                            padding: const EdgeInsets.symmetric(),
                            decoration: const BoxDecoration(
                                color: AppColors.secondaryContainer),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  child: Container(
                                    width: size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding,
                                        vertical: defaultPadding),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding / 2,
                                        vertical: defaultPadding / 2),
                                    decoration: BoxDecoration(
                                        color: widget.topic.colorValue,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: defaultPadding * 2,
                                              vertical: defaultPadding),
                                          child: Text(
                                            "Read carefully and understand",
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
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: snapshot.connectionState ==
                                                    ConnectionState.waiting
                                                ? const LoadingSpinner()
                                                : Builder(builder: (context) {
                                                    Exercise exercise = snapshot
                                                        .data!.models.first;

                                                    return exercise.test != null
                                                        ? Text(
                                                            exercise.test!,
                                                            style:
                                                                const TextStyle(
                                                                    height: 2),
                                                          )
                                                        : const Text(
                                                            "Exercise does not have example text",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12),
                                                            textAlign: TextAlign
                                                                .center,
                                                          );
                                                  }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding,
                                        vertical: defaultPadding * 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Your Exercise",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: defaultPadding,
                                        ),
                                        Expanded(
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: Builder(
                                                key: ValueKey<bool>(
                                                    snapshot.hasData),
                                                builder: (context) {
                                                  if (snapshot.hasData &&
                                                      snapshot
                                                          .data!.isSuccess) {
                                                    Exercise exercise = snapshot
                                                        .data!.models.first;

                                                    return AutoSizeText(
                                                      exercise.description,
                                                      style: const TextStyle(
                                                          fontSize: 22,
                                                          height: 2),
                                                    );
                                                  } else {
                                                    return const Column(
                                                      children: [
                                                        LoadingSpinner(),
                                                        SizedBox(
                                                          height:
                                                              defaultPadding /
                                                                  2,
                                                        ),
                                                        Text(
                                                          "Getting Exercise",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        )
                                                      ],
                                                    );
                                                  }
                                                }),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                        // return const LoadingSpinner();
                      }),
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
                              snapshot.hasData && snapshot.data!.isSuccess
                                  ? TapBounce(
                                      onTap: () {},
                                      curve: Curves.bounceInOut,
                                      child: PrimaryButton(
                                        color: AppColors.buttonColor,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Proceed to Submission",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              width: defaultPadding,
                                            ),
                                            Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white
                                                      .withOpacity(0.1)),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
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
