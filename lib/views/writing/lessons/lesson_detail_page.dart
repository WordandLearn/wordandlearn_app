import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/utils/timer.dart';
import 'package:word_and_learn/views/writing/lessons/components/lesson_header_container.dart';
import 'package:word_and_learn/views/writing/topic/lesson_topics_page.dart';

class LessonDetailPage extends StatefulWidget {
  const LessonDetailPage(
      {super.key, required this.lesson, required this.isAvailable});
  final Lesson lesson;
  final bool isAvailable;

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  final WritingController writingController = Get.find<WritingController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: LessonHeaderContainer(
            lesson: widget.lesson,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: Text(
            widget.lesson.description,
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 22),
          ),
        ),
        TimedWidget(
          duration: TimerUtil.timeToRead(widget.lesson.description) * 0.9,
          child: SizedBox(
            width: 300,
            child: widget.isAvailable
                ? PrimaryButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LessonTopicsPage(lesson: widget.lesson),
                              settings: const RouteSettings(
                                  name: "LessonTopicsPage")));
                    },
                    // color: Theme.of(context).colorScheme.secondary,
                    child: const Text(
                      "Go To Lesson",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  )
                : Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.lock_circle_fill),
                          SizedBox(
                            width: defaultPadding,
                          ),
                          Text("Lesson Locked",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.greyTextColor)),
                        ],
                      ),
                      const SizedBox(
                        height: defaultPadding / 2,
                      ),
                      Text(
                        writingController.subscriptionStatus != null
                            ? writingController.subscriptionStatus ==
                                    SubscriptionStatus.trialActive
                                ? widget.lesson.number > 1
                                    ? "Subscribe to access this lesson"
                                    : "Complete Previous Lesson"
                                : "Complete Previous Lesson"
                            : "Complete Previous Lesson",
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.greyTextColor),
                      )
                    ],
                  ),
          ),
        )
      ],
    );
  }
}
