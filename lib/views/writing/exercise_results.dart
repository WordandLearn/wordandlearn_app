import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';

class ExerciseResultsPage extends StatelessWidget {
  const ExerciseResultsPage(
      {super.key, required this.exerciseSubmission, required this.exercise});

  final ExerciseSubmission exerciseSubmission;
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: const Padding(
          padding: allPadding,
          child: Row(
            children: [CustomBackButton()],
          ),
        ),
        body: ListView(
          children: const [],
        ));
  }
}
