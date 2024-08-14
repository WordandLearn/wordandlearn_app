import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/writing/topic/mini_activity_page.dart';

import 'dialog_audio_player.dart';

class FlashCardDialog extends StatefulWidget {
  const FlashCardDialog({
    super.key,
    required this.size,
    required this.flashcardText,
    required this.onUnderstand,
  });

  final Size size;
  final FlashcardText flashcardText;
  final void Function() onUnderstand;

  @override
  State<FlashCardDialog> createState() => _FlashCardDialogState();
}

class _FlashCardDialogState extends State<FlashCardDialog> {
  double rotation = 0.001;
  bool listeningComplete = false;
  late Future<File?> _audioFuture;
  final WritingController _writingController = Get.find<WritingController>();
  void _animateRotation() {
    if (mounted) {
      setState(() {
        rotation = 0;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            rotation = 0.002;
          });
        }
      });
    }
  }

  @override
  void initState() {
    _audioFuture =
        _writingController.getFlashcardAudio(widget.flashcardText.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size.height * 0.7 + 50,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          Positioned(
            top: -60,
            right: 0,
            child: Image.asset(
              "assets/stickers/cat_analyst.png",
              width: 100,
            ),
          ),
          AnimatedRotation(
            turns: rotation,
            duration: const Duration(milliseconds: 1),
            child: Container(
              height: widget.size.height * 0.7,
              margin:
                  const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding * 2, vertical: defaultPadding * 2),
              width: 350,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: widget.flashcardText.colorValue,
                  boxShadow: [
                    BoxShadow(
                        color:
                            widget.flashcardText.darkerColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 10))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: DialogAudioWidget(
                      future: _audioFuture,
                      color: widget.flashcardText,
                      onCompleted: () {
                        setState(() {
                          listeningComplete = true;
                        });
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: AutoSizeText(
                      widget.flashcardText.text,
                      style: const TextStyle(fontSize: 22, height: 2),
                    ),
                  )
                ],
              ),
            ),
          ),
          widget.flashcardText.completed
              ? const SizedBox.shrink()
              : Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _FlashCardButton(
                      flashcardText: widget.flashcardText,
                      completed: listeningComplete,
                      onTap: () {
                        _animateRotation();
                        widget.onUnderstand();
                      },
                    ),
                  ),
                )
        ],
      ),
    );
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
  double scale = 1;

  void _animateBounce() {
    setState(() {
      scale = 1.02;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        scale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceInOut,
        child: GestureDetector(
          onTap: () {
            _animateBounce();
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
      ),
    );
  }
}
