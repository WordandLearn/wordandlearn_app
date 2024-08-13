import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/utils/timer.dart';
import 'package:word_and_learn/views/writing/topic/components/dialog_audio_player.dart';

class ExampleDialog extends StatefulWidget {
  const ExampleDialog({
    super.key,
    t,
    required this.example,
    this.onUnderstand,
  });

  final Example example;
  final void Function()? onUnderstand;

  @override
  State<ExampleDialog> createState() => _ExampleDialogState();
}

class _ExampleDialogState extends State<ExampleDialog> {
  bool understood = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Container(
        constraints: const BoxConstraints(minHeight: 300),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -50,
              right: 0,
              child: Image.asset(
                "assets/stickers/cat_angel.png",
                width: 90,
              ),
            ),
            Container(
              height: 350,
              width: size.width,
              // width: size.width,
              margin: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              padding: const EdgeInsetsDirectional.all(defaultPadding * 2),
              decoration: BoxDecoration(
                  color: widget.example.darkerColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _ExampleAudioWidget(
                      example: widget.example,
                      onCompleted: () {
                        setState(() {
                          understood = true;
                        });
                      }),
                  AutoSizeText(
                    widget.example.guide,
                    style: const TextStyle(fontSize: 18, height: 2),
                  ),
                ],
              ),
            ),
            !widget.example.completed
                ? Positioned(
                    bottom: -20,
                    left: 0,
                    right: 0,
                    child: Center(
                        child: TapBounce(
                            child: ExampleDialogButton(
                      example: widget.example,
                      onUnderstood: widget.onUnderstand,
                      understood: understood,
                    ))))
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

class _ExampleAudioWidget extends StatefulWidget {
  const _ExampleAudioWidget({required this.example, required this.onCompleted});
  final Example example;
  final void Function() onCompleted;

  @override
  State<_ExampleAudioWidget> createState() => _ExampleAudioWidgetState();
}

class _ExampleAudioWidgetState extends State<_ExampleAudioWidget> {
  late Future<File?> future;

  final WritingController _writingController = Get.find<WritingController>();

  @override
  void initState() {
    future = _writingController.getExampleAudio(widget.example.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DialogAudioWidget(
        onCompleted: widget.onCompleted, future: future, color: widget.example);
  }
}

class ExampleDialogButton extends StatefulWidget {
  const ExampleDialogButton({
    super.key,
    required this.example,
    required this.understood,
    this.onUnderstood,
  });
  final Example example;
  final bool understood;
  final void Function()? onUnderstood;

  @override
  State<ExampleDialogButton> createState() => _ExampleDialogButtonState();
}

class _ExampleDialogButtonState extends State<ExampleDialogButton> {
  bool timerComplete = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: InkWell(
        onTap: () {
          if (widget.understood) {
            widget.onUnderstood!();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceInOut,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color:
                  widget.understood ? widget.example.darkerColor : Colors.white,
              borderRadius: BorderRadius.circular(20)),
          child: AnimatedSwitcher(
              duration: TimerUtil.timeToRead(widget.example.guide),
              child: widget.understood
                  ? Row(
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
                          padding:
                              EdgeInsets.symmetric(horizontal: defaultPadding),
                          child: Text(
                            "I Understand",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        )
                      ],
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Finish Listening To Continue",
                            style: TextStyle(fontSize: 12))
                      ],
                    )),
        ),
      ),
    );
  }
}
