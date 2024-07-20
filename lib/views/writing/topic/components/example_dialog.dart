import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/utils/timer.dart';

class ExampleDialogButton extends StatefulWidget {
  const ExampleDialogButton(
      {super.key, required this.example, this.onUnderstand});
  final Example example;
  final void Function()? onUnderstand;

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
          if (timerComplete) {
            Future.delayed(const Duration(milliseconds: 200), () {
              widget.onUnderstand!();
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceInOut,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: timerComplete ? widget.example.darkerColor : Colors.white,
              borderRadius: BorderRadius.circular(20)),
          child: TimedWidget(
              duration: TimerUtil.timeToRead(widget.example.guide),
              color: widget.example.darkerColor,
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
    );
  }
}
