import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:word_and_learn/constants/colors.dart';

class LoadingSpinner extends StatefulWidget {
  const LoadingSpinner({super.key, this.color, this.size});
  final Color? color;
  final double? size;

  @override
  State<LoadingSpinner> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> colorAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
    colorAnimation =
        ColorTween(begin: AppColors.primaryColor, end: AppColors.secondaryColor)
            .animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return SpinKitRing(
            color: colorAnimation.value ?? Theme.of(context).primaryColor,
            size: widget.size ?? 30,
            lineWidth: 1.5,
          );
        });
  }
}
