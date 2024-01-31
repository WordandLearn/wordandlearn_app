import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/utils/timer.dart';

Widget buildGuideTextDialog(BuildContext context, String guideText) {
  return Dialog(
    child: Container(
        height: 400,
        // padding: allPadding,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: allPadding,
              child: Container(
                  height: 330,
                  width: 300,
                  padding: const EdgeInsets.fromLTRB(
                      defaultPadding * 2,
                      defaultPadding * 2,
                      defaultPadding * 2,
                      defaultPadding * 4),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: AutoSizeText(
                    guideText,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white),
                  )),
            ),
            const Positioned(bottom: -20, left: -30, child: Mascot(size: 130)),
            Positioned(
              bottom: defaultPadding * 2,
              right: defaultPadding * 2,
              child: TimedWidget(
                  duration: TimerUtil.timeToRead(guideText),
                  child: SizedBox(
                    width: 130,
                    height: 30,
                    child: CustomPrimaryButton(
                      text: "I understand",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )),
            )
          ],
        )),
  );
}
