import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/writing/exercise/exercise_page.dart';
import 'package:word_and_learn/views/writing/lessons/components/session_error_dialog.dart';
import 'package:word_and_learn/views/writing/lessons/components/session_success_dialog.dart';
import 'package:word_and_learn/views/writing/topic/topic_learn_page.dart';

class LessonTopicCard extends StatefulWidget {
  const LessonTopicCard({
    super.key,
    required this.topic,
    required this.lesson,
    this.isAvailable = true,
  });

  final Topic topic;
  final Lesson lesson;
  final bool isAvailable;

  @override
  State<LessonTopicCard> createState() => _LessonTopicCardState();
}

class _LessonTopicCardState extends State<LessonTopicCard> {
  final WritingController _writingController = Get.find<WritingController>();
  double scale = 1;

  void _animateBounce() {
    setState(() {
      scale = 0.99;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        scale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.5,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: () {
              _animateBounce();
              if (widget.isAvailable) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TopicLearnPage(
                              topic: widget.topic,
                              lesson: widget.lesson,
                              onCompleted: () {
                                setState(() {
                                  widget.topic.completed = true;
                                });
                              },
                            ),
                        settings: const RouteSettings(name: "TopicLearnPage")));
              } else {
                showDialog(
                  context: context,
                  builder: (context) => const SessionErrorDialog(
                      title: "Cannot Access Topic",
                      reason: "Complete previous topic to unlock"),
                );
              }
            },
            child: AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.6,
                    width: size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding * 2,
                        vertical: defaultPadding * 2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            widget.topic.image!,
                            height: 120,
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding * 2,
                                vertical: defaultPadding / 1.5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.secondaryColor),
                            child: AutoSizeText(
                              widget.topic.tag,
                              maxLines: 1,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding),
                          child: Center(
                            child: AutoSizeText(
                              widget.topic.title,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            widget.topic.description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !widget.isAvailable,
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.6,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.lock_circle_fill,
                            size: 50,
                          ),
                          Text(
                            "Complete Previous Topic To Unlock",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<Exercise?>(
              future: _writingController.getTopicExercise(widget.topic.id),
              builder: (context, snapshot) {
                return Positioned(
                  bottom: 4,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (widget.topic.completed) {
                          if (widget.topic.exerciseCompleted) {
                            showDialog(
                              context: context,
                              builder: (context) => const SessionSuccessDialog(
                                  title: "Hooray",
                                  reason:
                                      "Good job you completed this exercise"),
                            );
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ExercisePage(topic: widget.topic),
                                    settings: const RouteSettings(
                                        name: "ExercisePage")));
                          }
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const SessionErrorDialog(
                                  title: "You cannot access this exercise",
                                  reason:
                                      "Complete the topic to access the exercise we made just for you",
                                );
                              });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding * 1.5,
                            vertical: defaultPadding),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: widget.topic.completed
                                ? widget.topic.exerciseCompleted
                                    ? AppColors.greenColor
                                    : Theme.of(context).primaryColor
                                : AppColors.inactiveColor,
                            border: widget.topic.completed
                                ? widget.topic.exerciseCompleted
                                    ? Border.all(
                                        color: AppColors.buttonColor
                                            .withOpacity(0.6))
                                    : null
                                : null,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 2),
                                  blurRadius: 5)
                            ]),
                        child: widget.topic.completed
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/brain.svg",
                                    width: 20,
                                    theme: const SvgTheme(
                                        currentColor: Colors.black),
                                    // color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: defaultPadding,
                                  ),
                                  Text(
                                    widget.topic.exerciseCompleted
                                        ? "Exercise Completed"
                                        : "Attempt Exercise",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.w600),
                                  )
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/icons/lock.svg",
                                      width: 20,
                                      theme: const SvgTheme(
                                          currentColor: Colors.white),
                                      // ignore: deprecated_member_use
                                      color: Colors.white),
                                  const SizedBox(
                                    width: defaultPadding,
                                  ),
                                  Text(
                                    "Exercise Not Accessible",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
