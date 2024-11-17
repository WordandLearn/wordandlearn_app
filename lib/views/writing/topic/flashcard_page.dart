import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/utils/timer.dart';
import 'package:word_and_learn/views/writing/topic/components/dialog_audio_player.dart';
import 'package:word_and_learn/views/writing/topic/mini_activity_page.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage(
      {super.key, required this.flashcardText, required this.onComplete});
  final FlashcardText flashcardText;
  final void Function() onComplete;

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final WritingController _writingController = Get.find<WritingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.flashcardText.colorValue,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            widget.flashcardText.title!,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding, horizontal: defaultPadding * 2),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: DialogAudioWidget(
                          onCompleted: () {},
                          future: _writingController
                              .getFlashcardAudio(widget.flashcardText.id),
                          color: widget.flashcardText),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: AutoSizeText(
                          widget.flashcardText.text,
                          style: const TextStyle(fontSize: 22, height: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding * 2, horizontal: defaultPadding * 2),
              child: Column(
                children: [
                  Divider(
                    color: widget.flashcardText.colorValue,
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  TimedWidget(
                    duration: TimerUtil.timeToRead(widget.flashcardText.text),
                    child: _FlashCardButton(
                        flashcardText: widget.flashcardText,
                        onTap: () {
                          widget.onComplete();
                        },
                        completed: true),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class _FlashCardButton extends StatefulWidget {
  const _FlashCardButton({
    required this.flashcardText,
    required this.onTap,
    this.completed = false,
  });

  final FlashcardText flashcardText;
  final void Function() onTap;
  final bool completed;
  @override
  State<_FlashCardButton> createState() => _FlashCardButtonState();
}

class _FlashCardButtonState extends State<_FlashCardButton> {
  @override
  Widget build(BuildContext context) {
    return TapBounce(
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
      child: GestureDetector(
        onTap: () {
          if (widget.completed) {
            if (widget.flashcardText.miniActivity != null) {
              showModalBottomSheet(
                context: context,
                isDismissible: false,
                builder: (context) {
                  return MiniActivityPage(
                    miniActivity: widget.flashcardText.miniActivity!,
                    colorModel: widget.flashcardText,
                    onUnderstand: () {
                      Navigator.pop(context);
                      widget.onTap();
                    },
                  );
                },
              );
            } else {
              Future.delayed(const Duration(milliseconds: 400), () {
                widget.onTap();
              });
            }
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceInOut,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: widget.completed
                  ? widget.flashcardText.darkerColor
                  : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20)),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: !widget.completed
                ? const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.info),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Text(
                        "Finish Listening To Continue",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                : widget.flashcardText.miniActivity != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: Text(
                              "Do Activity",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Icon(
                              Icons.done_rounded,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: defaultPadding / 2,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: Text(
                              "I Understand",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
