import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class SmallButton extends StatefulWidget {
  const SmallButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
  });
  final String text;
  final Widget? icon;
  final void Function()? onPressed;

  @override
  State<SmallButton> createState() => _SmallButtonState();
}

class _SmallButtonState extends State<SmallButton> {
  double scale = 1;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          scale = 0.9;
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            scale = 1;
          });
        });
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding / 1.5),
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)),
          // alignment: Alignment.centerRight,
          child: Row(
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
