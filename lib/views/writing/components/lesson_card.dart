import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/utils/color_utils.dart';

class LessonCard extends StatefulWidget {
  const LessonCard({
    super.key,
    required this.lesson,
  });
  final Lesson lesson;

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  double width = 200;
  double height = 400;

  @override
  Widget build(BuildContext context) {
    Color cardColor = widget.lesson.color ?? ColorUtils.randomHueFromColor();

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Container(
              width: width,
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding * 2),
              decoration: BoxDecoration(
                  color: cardColor, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.white,
                  ),
                  Column(
                    children: [
                      Text(
                        widget.lesson.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 26),
                      ),
                      widget.lesson.progress != null
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: defaultPadding),
                                  child: Text(
                                    "${widget.lesson.progress!.completed}/${widget.lesson.progress!.total}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ),
                                ProgressBar(
                                  height: 10,
                                  width: 150,
                                  progress: widget.lesson.progress!.progress,
                                ),
                              ],
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding / 2,
                          horizontal: defaultPadding),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            color: cardColor,
                          ),
                          const SizedBox(
                            width: defaultPadding / 2,
                          ),
                          Text(
                            "Continue",
                            style: TextStyle(
                                color: cardColor, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
          !widget.lesson.unlocked
              ? Container(
                  width: width,
                  height: 400,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.lock_fill,
                        color: Colors.white,
                      ),
                      Text(
                        "Locked",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar(
      {super.key,
      required this.height,
      required this.width,
      this.progress = 0,
      this.color});
  final double height;
  final double width;
  final double progress;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: color ?? Colors.white,
              borderRadius: BorderRadius.circular(20)),
        ),
        Container(
          width: width * progress,
          height: height + 2,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20)),
        ),
      ],
    );
  }
}
