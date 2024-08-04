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
      required this.onProgress,
      required this.onComplete});
  final Topic topic;
  final Lesson lesson;
  final void Function(double progress) onProgress;
  final void Function() onComplete;

  @override
  State<TopicNotesPage> createState() => _TopicNotesPageState();
}

class _TopicNotesPageState extends State<TopicNotesPage> {
  final WritingController _writingController = Get.find<WritingController>();
  late Future<List<FlashcardText>?> _future;

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
    // Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<FlashcardText>?>(
        future: _future,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Builder(builder: (context) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: snapshot.hasData
                    ? FlashcardList(
                        flashCards: snapshot.data!,
                        onUnderstand: (int index) {
                          FlashcardText flashcardText = snapshot.data![index];
                          if (!flashcardText.completed) {
                            _writingController
                                .markFlashcardCompleted(flashcardText);
                            setState(() {
                              flashcardText.setCompleted();
                            });
                          }
                          double progress = _notesProgress(snapshot.data!);
                          widget.onProgress(progress);
                          if (progress == 1) {
                            widget.onComplete();
                          }
                          Navigator.pop(context);
                        },
                        onLoad: () {
                          //update progress
                          _notesProgress(snapshot.data!);
                        })
                    : const LoadingSpinner(),
              );
            }),
          );
        });
  }
}

class FlashcardList extends StatefulWidget {
  const FlashcardList(
      {super.key,
      required this.flashCards,
      required this.onUnderstand,
      required this.onLoad});

  final List<FlashcardText> flashCards;
  final void Function(int index) onUnderstand;
  final void Function() onLoad;

  @override
  State<FlashcardList> createState() => _FlashcardListState();
}

class _FlashcardListState extends State<FlashcardList> {
  int activeFlashcard = 0;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      widget.onLoad();
    });
    _makeFirstNotCompletedActive();
    super.initState();
  }

  void _makeFirstNotCompletedActive() {
    for (int i = 0; i < widget.flashCards.length; i++) {
      if (!widget.flashCards[i].completed) {
        setState(() {
          activeFlashcard = i;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: widget.flashCards.length,
      itemBuilder: (context, index) {
        FlashcardText flashcardText = widget.flashCards[index];
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
                    barrierDismissible: flashcardText.completed,
                    builder: (context) {
                      return SizedBox(
                        height: 300,
                        child: Center(
                          child: FlashCardDialog(
                            size: size,
                            flashcardText: flashcardText,
                            onUnderstand: () => widget.onUnderstand(index),
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
    );
  }
}
