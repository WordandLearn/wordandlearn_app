import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/exercise_page.dart';
import 'package:word_and_learn/views/writing/topic/topic_learn_page.dart';

import '../../../../constants/constants.dart';

class TopicProgressItem extends StatefulWidget {
  const TopicProgressItem({
    super.key,
    this.width,
    required this.topic,
    required this.index,
    required this.isComplete,
    required this.isCurrent,
  });
  final double? width;
  final Topic topic;
  final bool isComplete;
  final bool isCurrent;
  final int index;

  @override
  State<TopicProgressItem> createState() => _TopicProgressItemState();
}

class _TopicProgressItemState extends State<TopicProgressItem> {
  double itemWidth = 0;

  @override
  void initState() {
    if (widget.width != null) {
      setState(() {
        itemWidth = widget.width!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicLearnPage(topic: widget.topic),
                ));
          },
          child: _TopicProgressCard(
            widget: widget,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExercisePage(
                    topic: widget.topic,
                  ),
                ));
          },
          child: _TopicExerciseCard(
            topic: widget.topic,
          ),
        )
      ],
    );
  }
}

class _TopicExerciseCard extends StatefulWidget {
  const _TopicExerciseCard({super.key, required this.topic});
  final Topic topic;

  @override
  State<_TopicExerciseCard> createState() => _TopicExerciseCardState();
}

class _TopicExerciseCardState extends State<_TopicExerciseCard> {
  @override
  void initState() {
    if (widget.topic.completed) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Column(
          children: [
            Container(
                height: 70,
                width: widget.topic.isCurrent ? size.width * 0.8 : 200,
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                decoration: BoxDecoration(
                  color: !widget.topic.completed
                      ? AppColors.inactiveColor
                      : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: widget.topic.completed
                    ? const _LockedIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Exercise",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.w600),
                          )
                        ],
                      )),
            Container(
              width: 5,
              height: 70,
              decoration: BoxDecoration(
                  color: !widget.topic.completed
                      ? AppColors.inactiveColor
                      : Theme.of(context).primaryColor),
            ),
          ],
        ));
  }
}

class _TopicProgressCard extends StatelessWidget {
  const _TopicProgressCard({
    super.key,
    required this.widget,
  });

  final TopicProgressItem widget;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = widget.isComplete
        ? widget.topic.isCurrent
            ? size.width * 0.9
            : size.width * 0.7
        : size.width * 0.7;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          SizedBox(
            width: width,
            child: Container(
                // height: 70,

                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding * 2, vertical: defaultPadding),
                decoration: BoxDecoration(
                  color: widget.isComplete
                      ? widget.topic.isCurrent
                          ? Theme.of(context).primaryColor
                          : AppColors.inactiveColor
                      : AppColors.inactiveColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: widget.topic.isLocked
                    ? const _LockedIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Center(
                                child: Text(
                              (widget.index + 1).toString(),
                              style: Theme.of(context).textTheme.titleLarge,
                            )),
                          ),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          Expanded(
                            child: Text(
                              widget.topic.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          widget.topic.isCurrent
                              ? const CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      defaultImageUrl),
                                )
                              : const SizedBox(
                                  width: 30,
                                ),
                        ],
                      )),
          ),
          Container(
            width: 5,
            height: 30,
            decoration: BoxDecoration(
                color: widget.isCurrent
                    ? Theme.of(context).primaryColor
                    : Colors.grey),
          )
        ],
      ),
    );
  }
}

class _LockedIndicator extends StatelessWidget {
  const _LockedIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 25,
          height: 25,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: const Center(
              child: Icon(
            CupertinoIcons.lock,
            size: 15,
          )),
        ),
        const SizedBox(
          width: defaultPadding,
        ),
        Text(
          "Locked",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white),
        )
      ],
    );
  }
}
