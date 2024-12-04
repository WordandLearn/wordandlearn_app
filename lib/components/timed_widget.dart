import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class TimedWidget extends StatefulWidget {
  const TimedWidget(
      {super.key,
      required this.child,
      required this.duration,
      this.onCompleted,
      this.color});
  final Widget child;
  final Duration duration;
  final Function()? onCompleted;
  final Color? color;

  @override
  State<TimedWidget> createState() => _TimedWidgetState();
}

class _TimedWidgetState extends State<TimedWidget>
    with SingleTickerProviderStateMixin {
  bool timeElapsed = false;
  CountDownController countDownController = CountDownController();
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();

    // _colorAnimation =
    //     ColorTween(begin: AppColors.primaryColor, end: AppColors.secondaryColor)
    //         .animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: timeElapsed
          ? widget.child
          : AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CircularCountDownTimer(
                  width: 30,
                  height: 30,
                  isReverse: true,
                  isReverseAnimation: true,
                  duration: widget.duration.inSeconds,
                  strokeWidth: 2.5,
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  strokeCap: StrokeCap.round,
                  fillColor: AppColors.secondaryColor,
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
                );
              }),
    );
  }
}
