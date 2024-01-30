import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.child,
    this.onPressed,
  });
  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
      child: child,
    );
  }
}
