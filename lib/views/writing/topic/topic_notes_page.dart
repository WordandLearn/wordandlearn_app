import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/topic/components/flash_card_dialog.dart';
import 'package:word_and_learn/views/writing/topic/components/topic_note_card.dart';

class TopicNotesPage extends StatefulWidget {
  const TopicNotesPage(
      {super.key,
      required this.topic,
      required this.lesson,
      required this.onProgress});
  final Topic topic;
  final Lesson lesson;
  final void Function(double progress) onProgress;

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

  double _notesProgress(List<FlashcardText> flashcards) {
    int completed = 0;
    for (var flashcard in flashcards) {
      if (flashcard.completed) {
        completed++;
      }
    }
    double progress = completed / flashcards.length;
    widget.onProgress(progress);
    return progress;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: FutureBuilder<HttpResponse<FlashcardText>>(
          future: _future,
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       vertical: defaultPadding, horizontal: defaultPadding),
                //   child: Text(
                //     "Lesson Notes",
                //     style: Theme.of(context)
                //         .textTheme
                //         .bodyLarge!
                //         .copyWith(fontWeight: FontWeight.bold),
                //   ),
                // ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
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
                                          ? -0.00125
                                          : 0.00125,
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
                                              flashcardText.completed,
                                          builder: (context) {
                                            return SizedBox(
                                              height: 300,
                                              child: Center(
                                                child: FlashCardDialog(
                                                  size: size,
                                                  flashcardText: flashcardText,
                                                  onUnderstand: () {
                                                    //TODO: Update Api with progress and an indicator if the last flashcard is understood trigger examples
                                                    setState(() {
                                                      flashcardText
                                                          .setCompleted();
                                                    });
                                                    double progress =
                                                        _notesProgress(snapshot
                                                            .data!.models);
                                                    widget.onProgress(progress);
                                                    Navigator.pop(context);
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
          }),
    );
  }
}
