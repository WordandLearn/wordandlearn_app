import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    this.color,
    this.onPressed,
  });
  final Widget icon;
  final Color? color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: color ?? Theme.of(context).primaryColor),
        onPressed: () {
          if (onPressed != null) {
            log("BEING PRESSED");
            onPressed!();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding * 1.5),
          child: icon,
        ));
  }
}
