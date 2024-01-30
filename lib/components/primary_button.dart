import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.child,
    this.onPressed,
    this.color,
    this.borderRadius = 40,
  });
  final Widget child;
  final Color? color;
  final double borderRadius;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
      child: child,
    );
  }
}
