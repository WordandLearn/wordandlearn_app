import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class TimedWidget extends StatefulWidget {
  const TimedWidget(
      {super.key,
      required this.child,
      required this.duration,
      this.onCompleted});
  final Widget child;
  final Duration duration;
  final Function()? onCompleted;

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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: timeElapsed
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
                if (widget.onCompleted != null) {
                  widget.onCompleted!();
                }
              },
              ringColor: Theme.of(context).primaryColor,
            ),
    );
  }
}
