import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/utils/color_utils.dart';

class RadioInput extends StatelessWidget {
  const RadioInput({
    super.key,
    this.isActive = false,
    required this.label,
  });
  final bool isActive;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1.05 : 1,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
            color: isActive
                ? ColorUtils.darkenColor(color: AppColors.secondaryColor)
                : AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding * 2, vertical: defaultPadding * 1.5),
        child: Row(
          children: [
            Container(
              width: 25,
              height: 25,
              padding: const EdgeInsets.all(defaultPadding / 2),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.withOpacity(0.3))),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? ColorUtils.darkenColor(
                            color: AppColors.secondaryColor)
                        : Colors.white),
              ),
            ),
            const SizedBox(
              width: defaultPadding,
            ),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? Colors.black : Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
