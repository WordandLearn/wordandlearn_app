import 'package:flutter/material.dart';
import 'package:word_and_learn/models/topic.dart';
import 'package:word_and_learn/views/writing/topic/components/topic_progress_item.dart';

class TopicProgress extends StatefulWidget {
  const TopicProgress({super.key, required this.topics, this.activeTopic});
  final List<Topic> topics;
  final Topic? activeTopic;

  @override
  State<TopicProgress> createState() => _TopicProgressState();
}

class _TopicProgressState extends State<TopicProgress> {
  int activeTopicIndex = 1;

  @override
  void initState() {
    if (widget.activeTopic != null) {
      activeTopicIndex = widget.topics.indexOf(widget.activeTopic!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.topics.length, (index) {
        return TopicProgressItem(
          topic: widget.topics[index],
          isCurrent: index == activeTopicIndex,
          isComplete: index <= activeTopicIndex,
          index: index,
        );
      }),
    );
  }
}
