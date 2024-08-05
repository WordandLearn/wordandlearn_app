import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';

class ExerciseDetailsPage extends StatelessWidget {
  const ExerciseDetailsPage(
      {super.key, required this.topic, required this.snapshot});
  final Topic topic;
  final AsyncSnapshot<Exercise?> snapshot;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: size.height,
        padding: const EdgeInsets.symmetric(),
        decoration: const BoxDecoration(color: AppColors.secondaryContainer),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: size.width,
                margin: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding / 2,
                    vertical: defaultPadding / 2),
                decoration: BoxDecoration(
                    color: topic.colorValue,
                    borderRadius: BorderRadius.circular(40)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding * 2,
                          vertical: defaultPadding),
                      child: Text(
                        "Read carefully and understand",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
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
                          horizontal: defaultPadding, vertical: defaultPadding),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child:
                            snapshot.connectionState == ConnectionState.waiting
                                ? const LoadingSpinner()
                                : Builder(builder: (context) {
                                    Exercise exercise = snapshot.data!;

                                    return exercise.test != null
                                        ? Text(
                                            exercise.test!,
                                            style: const TextStyle(height: 2),
                                          )
                                        : const Text(
                                            "Exercise does not have example text",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                            textAlign: TextAlign.center,
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
                margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Exercise",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Builder(
                          key: ValueKey<bool>(snapshot.hasData),
                          builder: (context) {
                            if (snapshot.hasData) {
                              Exercise exercise = snapshot.data!;

                              return AutoSizeText(
                                exercise.description,
                                maxLines: 4,
                                style: const TextStyle(fontSize: 22, height: 2),
                              );
                            } else {
                              return const Column(
                                children: [
                                  LoadingSpinner(),
                                  SizedBox(
                                    height: defaultPadding / 2,
                                  ),
                                  Text(
                                    "Getting Exercise",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              );
                            }
                          }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
