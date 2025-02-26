import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/writing/lessons/lesson_detail_page.dart';

class LessonCard extends StatefulWidget {
  const LessonCard({
    super.key,
    required this.lesson,
    this.isAvaliable = false,
    this.width,
    this.height,
  });

  final Lesson lesson;
  final bool isAvaliable;
  final double? width;
  final double? height;

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  double scale = 1;
  void _startBounceAnimation({double value = 0.98}) {
    setState(() {
      scale = value; // Set the target height for the bounce animation
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        scale = 1; // Reset the height after the bounce animation
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: widget.lesson.colorValue.withOpacity(0.3),
      onLongPress: () {
        _startBounceAnimation(value: 0.95);
      },
      onTap: () {
        _startBounceAnimation();
        Future.delayed(const Duration(milliseconds: 200), () {
          if (!context.mounted) {
            return;
          }
          if (widget.lesson.unlocked) {
            showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                builder: (context) {
                  return SizedBox(
                      height: 600,
                      width: size.width,
                      child: Padding(
                        padding: allPadding,
                        child: LessonDetailPage(
                          lesson: widget.lesson,
                          isAvailable: widget.isAvaliable,
                        ),
                      ));
                });
          }
        });
      },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
        child: Stack(
          children: [
            Container(
              width: widget.width,
              height: widget.height,
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding * 2, horizontal: defaultPadding * 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: widget.isAvaliable
                      ? widget.lesson.color
                      : widget.lesson.color?.withOpacity(0.7)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Center(
                      child: AutoSizeText(
                        widget.lesson.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: FractionallySizedBox(
                        heightFactor: 0.7,
                        child: Image.asset(
                          widget.lesson.image!,
                          // height: 90,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !widget.isAvaliable,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20)),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.lock_circle_fill,
                      color: AppColors.greyTextColor,
                      size: 50,
                    ),
                    Text(
                      "Lesson Locked",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.greyTextColor),
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
