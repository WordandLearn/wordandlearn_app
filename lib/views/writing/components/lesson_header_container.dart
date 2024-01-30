import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class LessonHeaderContainer extends StatelessWidget {
  const LessonHeaderContainer({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
            vertical: defaultPadding, horizontal: defaultPadding * 2),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w600),
        ));
  }
}
