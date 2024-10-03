import 'package:flutter/material.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';

class SmallButton extends StatefulWidget {
  const SmallButton(
      {super.key,
      required this.text,
      this.icon,
      this.onPressed,
      this.isLoading = false});
  final String text;
  final Widget? icon;
  final bool isLoading;
  final void Function()? onPressed;

  @override
  State<SmallButton> createState() => _SmallButtonState();
}

class _SmallButtonState extends State<SmallButton> {
  double scale = 1;
  @override
  Widget build(BuildContext context) {
    return TapBounce(
      onTap: widget.onPressed,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding / 1.5),
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)),
          // alignment: Alignment.centerRight,
          child: widget.isLoading
              ? const Center(
                  child: LoadingSpinner(
                    color: AppColors.buttonColor,
                    size: 18,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.icon ?? const SizedBox.shrink(),
                    const SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Text(
                      widget.text,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
