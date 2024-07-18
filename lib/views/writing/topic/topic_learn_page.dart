import 'package:flutter/material.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/topic/topic_example_page.dart';

import 'components/topic_bottom_navbar.dart';
import 'topic_notes_page.dart';

class TopicLearnPage extends StatefulWidget {
  final Topic topic;
  final Lesson? lesson;
  const TopicLearnPage({super.key, required this.topic, this.lesson});

  @override
  State<TopicLearnPage> createState() => _TopicLearnPageState();
}

class _TopicLearnPageState extends State<TopicLearnPage> {
  bool completed = false;

  @override
  void initState() {
    super.initState();
  }

  int activePage = 0;
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: TopicBottomNavBar(
          onChanged: (index) {
            setState(() {
              activePage = index;
            });
          },
        ),
        body: SafeArea(
            child: IndexedStack(
          index: activePage,
          children: [
            TopicNotesPage(topic: widget.topic, lesson: widget.lesson!),
            TopicExamplePage(topic: widget.topic),
            const Scaffold()
          ],
        )));
  }
}
