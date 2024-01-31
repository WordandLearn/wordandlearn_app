import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class TimedWidget extends StatefulWidget {
  const TimedWidget({super.key, required this.child, required this.duration});
  final Widget child;
  final Duration duration;

  @override
  State<TimedWidget> createState() => _TimedWidgetState();
}

class _TimedWidgetState extends State<TimedWidget> {
  bool timeElapsed = false;
  CountDownController countDownController = CountDownController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return timeElapsed
        ? widget.child
        : CircularCountDownTimer(
            width: 30,
            height: 30,
            isReverse: true,
            isReverseAnimation: true,
            duration: widget.duration.inSeconds,
            strokeWidth: 2.5,
            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
            strokeCap: StrokeCap.round,
            fillColor: Colors.transparent,
            controller: countDownController,
            onComplete: () {
              setState(() {
                timeElapsed = true;
              });
            },
            ringColor: Theme.of(context).primaryColor,
          );
  }
}
