import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/components/add_composition_button.dart';
import 'package:word_and_learn/views/writing/components/composition_card.dart';
import 'package:word_and_learn/views/writing/components/current_lesson_card.dart';
import 'package:word_and_learn/views/writing/lessons_page.dart';

class WritingHome extends StatelessWidget {
  const WritingHome({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        bottomNavigationBar: const AddCompositionButton(),
        appBar: const ProfileAppBar(),
        body: ListView(
          children: [
            CurrentLessonCard(
              lesson: Lesson(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Compositions",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    itemCount: 1,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "/writing/lessons");
                          },
                          child: CompositionCard(
                            composition: Composition(),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ));
  }
}
