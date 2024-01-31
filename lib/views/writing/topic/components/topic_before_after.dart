import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/example.dart';
import 'package:word_and_learn/utils/timer.dart';

Color beforeColor = const Color(0xFF82E7FE);

Color afterColor = const Color(0xFFFFE482);

class TopicBeforeAfter extends StatelessWidget {
  const TopicBeforeAfter(
      {super.key,
      this.onNext,
      this.onPrevious,
      required this.example,
      this.isBefore = false});

  final Function()? onNext;
  final Function()? onPrevious;
  final Example example;
  final bool isBefore;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: defaultPadding * 6),
        decoration: BoxDecoration(
          color: isBefore ? beforeColor : afterColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isBefore ? "assets/icons/sad.svg" : "assets/icons/happy.svg",
              width: 70,
              height: 70,
            ),
            Text(
              isBefore ? "Before" : "After",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w500, fontSize: 26),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding * 4),
              child: Text(isBefore ? example.beforeText : example.afterText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.w600, height: 1.5)),
            ),
          ],
        ));
  }
}
