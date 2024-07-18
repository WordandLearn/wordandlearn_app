import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/topic/components/flash_card_dialog.dart';
import 'package:word_and_learn/views/writing/topic/components/topic_note_card.dart';

class TopicNotesPage extends StatefulWidget {
  const TopicNotesPage({super.key, required this.topic, required this.lesson});
  final Topic topic;
  final Lesson lesson;

  @override
  State<TopicNotesPage> createState() => _TopicNotesPageState();
}

class _TopicNotesPageState extends State<TopicNotesPage> {
  final WritingController _writingController = Get.find<WritingController>();
  late Future<HttpResponse<FlashcardText>> _future;

  int activeFlashcard = 0;

  @override
  void initState() {
    _future = _writingController.getTopicFlashcards(widget.topic.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<HttpResponse<FlashcardText>>(
        future: _future,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppbar(context, snapshot),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding, horizontal: defaultPadding),
                child: Text(
                  "Lesson Notes",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding),
                  child: snapshot.hasData && snapshot.data!.isSuccess
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.models.length,
                          itemBuilder: (context, index) {
                            FlashcardText flashcardText =
                                snapshot.data!.models[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: index % 2 != 0 ? defaultPadding : 0,
                                  right: index % 2 == 0 ? defaultPadding : 0),
                              child: AnimatedRotation(
                                turns: index == activeFlashcard
                                    ? 0
                                    : index % 2 != 0
                                        ? -0.0025
                                        : 0.0025,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut,
                                child: TopicNoteCard(
                                  flashcardText: flashcardText,
                                  onClicked: () {
                                    if (activeFlashcard != index) {
                                      setState(() {
                                        activeFlashcard = index;
                                      });
                                    } else {
                                      showDialog(
                                        context: context,
                                        barrierDismissible:
                                            flashcardText.completed ?? false,
                                        builder: (context) {
                                          return SizedBox(
                                            height: 300,
                                            child: Center(
                                              child: FlashCardDialog(
                                                size: size,
                                                flashcardText: flashcardText,
                                                onUnderstand: () {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    flashcardText
                                                        .setCompleted();
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  isOpened: index == activeFlashcard,
                                ),
                              ),
                            );
                          },
                        )
                      : const LoadingSpinner(),
                ),
              )
            ],
          );
        });
  }

  Widget buildAppbar(BuildContext context,
      AsyncSnapshot<HttpResponse<FlashcardText>> snapshot) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.chevron_left,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    widget.topic.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
