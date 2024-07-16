import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';

class TopicPageCard extends StatelessWidget {
  const TopicPageCard({
    super.key,
    required this.topic,
    this.onPressed,
  });

  final Topic topic;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsetsDirectional.all(defaultPadding),
            decoration: BoxDecoration(
                color: topic.isCurrent
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColor.withOpacity(0.4),
                shape: BoxShape.circle),
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/fire.svg",
                color: topic.isCurrent
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                width: 30,
                height: 30,
              ),
            ),
          ),
          const SizedBox(
            width: defaultPadding,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 18),
                ),
                const SizedBox(
                  height: defaultPadding / 4,
                ),
                Text(
                  topic.tag,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                )
              ],
            ),
          ),
          const SizedBox(
            width: defaultPadding,
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                shape: BoxShape.circle),
            child: Icon(
              Icons.lock,
              color: Theme.of(context).colorScheme.secondary,
              size: 15,
            ),
          )
        ],
      ),
    );
  }
}
