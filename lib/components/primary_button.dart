import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:word_and_learn/constants/constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.child,
    this.onPressed,
    this.color,
    this.borderRadius = 10,
    this.isLoading = false,
  });
  final Widget child;
  final Color? color;
  final double borderRadius;
  final void Function()? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 500),
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: color ?? Theme.of(context).primaryColor),
          child: Center(
              child: isLoading
                  ? const SpinKitRing(
                      lineWidth: 2.5,
                      color: Colors.white,
                      size: 30,
                    )
                  : child),
        ),
      ),
    );
  }
}

class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({
    super.key,
    this.color,
    required this.text,
    this.textStyle,
    this.onPressed,
    this.disabled = false,
    this.textColor,
  });

  final Color? color;
  final Color? textColor;
  final String text;
  final TextStyle? textStyle;
  final Function()? onPressed;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: disabled ? null : onPressed,
      child: Container(
        height: 60,
        width: size.width,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
            color: disabled
                ? Colors.grey
                : color ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            style: textStyle ??
                Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor ?? Colors.white),
          ),
        ),
      ),
    );
  }
}
