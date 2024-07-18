import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/timed_widget.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/utils/timer.dart';

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

  void _animateRotation() {
    setState(() {
      rotation = 0;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        rotation = 0.002;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
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
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding * 2, vertical: defaultPadding * 2),
            width: 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: widget.flashcardText.colorValue,
                boxShadow: [
                  BoxShadow(
                      color: widget.flashcardText.darkerColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 10))
                ]),
            child: Column(
              children: [
                Expanded(
                  child: AutoSizeText(
                    widget.flashcardText.text,
                    style: const TextStyle(fontSize: 22, height: 2),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(CupertinoIcons.volume_up),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        widget.flashcardText.completed != null &&
                widget.flashcardText.completed!
            ? const SizedBox.shrink()
            : Positioned(
                bottom: -30,
                left: 0,
                right: 0,
                child: Center(
                  child: _FlashCardButton(
                    flashcardText: widget.flashcardText,
                    onTap: () {
                      _animateRotation();
                      widget.onUnderstand();
                    },
                  ),
                ),
              )
      ],
    );
  }
}

class _FlashCardButton extends StatefulWidget {
  const _FlashCardButton({
    required this.flashcardText,
    required this.onTap,
  });

  final FlashcardText flashcardText;
  final void Function() onTap;
  @override
  State<_FlashCardButton> createState() => _FlashCardButtonState();
}

class _FlashCardButtonState extends State<_FlashCardButton> {
  bool timerComplete = false;
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
            if (timerComplete) {
              Future.delayed(const Duration(milliseconds: 400), () {
                widget.onTap();
              });
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.bounceInOut,
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
                color: timerComplete
                    ? widget.flashcardText.darkerColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(20)),
            child: TimedWidget(
                duration: TimerUtil.timeToRead(widget.flashcardText.text),
                color: widget.flashcardText.darkerColor,
                onCompleted: () {
                  setState(() {
                    timerComplete = true;
                  });
                },
                child: Row(
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
                      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                      child: Text(
                        "I Understand",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
