import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/exercise/exercise_page.dart';
import 'package:word_and_learn/views/writing/topic/topic_learn_page.dart';

class LessonTopicCard extends StatefulWidget {
  const LessonTopicCard({
    super.key,
    required this.topic,
    required this.lesson,
  });

  final Topic topic;
  final Lesson lesson;

  @override
  State<LessonTopicCard> createState() => _LessonTopicCardState();
}

class _LessonTopicCardState extends State<LessonTopicCard> {
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopicLearnPage(
                      topic: widget.topic,
                      lesson: widget.lesson,
                    ),
                  ));
            },
            child: AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              child: Container(
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
                        child: Text(
                          widget.topic.tag,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: Center(
                        child: AutoSizeText(
                          widget.topic.title,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Text(
                      widget.topic.description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 0,
            left: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (widget.topic.completed) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExercisePage(topic: widget.topic),
                        ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Complete topic to access exercise"),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: widget.topic.completed
                          ? Theme.of(context).primaryColor
                          : Colors.white70,
                      border: widget.topic.completed
                          ? Border.all(
                              color: AppColors.buttonColor.withOpacity(0.2))
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
                              theme: const SvgTheme(currentColor: Colors.black),
                              // color: Colors.black,
                            ),
                            const SizedBox(
                              width: defaultPadding,
                            ),
                            Text(
                              "Exercise",
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
                            SvgPicture.asset(
                              "assets/icons/lock.svg",
                              width: 20,
                              theme: const SvgTheme(currentColor: Colors.black),
                              // color: Colors.grey,
                            ),
                            const SizedBox(
                              width: defaultPadding,
                            ),
                            Text(
                              "Exercise Not Available",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey),
                            )
                          ],
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
