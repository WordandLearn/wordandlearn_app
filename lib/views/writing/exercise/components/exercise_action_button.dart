import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';

class ExerciseActionButton extends StatelessWidget {
  const ExerciseActionButton(
      {super.key,
      required this.selectImages,
      required this.currentPage,
      this.uploading = true,
      required this.onContinue});

  final int currentPage;
  final void Function() selectImages;
  final void Function() onContinue;
  final bool uploading;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: currentPage == 1
              ? TapBounce(
                  onTap: selectImages,
                  scale: 1.001,
                  child: const Row(
                    children: [
                      Icon(
                        CupertinoIcons.refresh_bold,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Text(
                        "Retake",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
        if (currentPage == 1)
          const Spacer(
            flex: 1,
          ),
        Expanded(
          flex: 4,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: TapBounce(
              scale: 1.01,
              onTap: onContinue,
              curve: Curves.bounceInOut,
              child: PrimaryButton(
                color: AppColors.buttonColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      !uploading
                          ? currentPage == 0
                              ? "Proceed to Submission"
                              : "Complete Exercise"
                          : "Uploading...",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.1)),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          child: !uploading
                              ? Icon(
                                  currentPage == 0
                                      ? Icons.keyboard_arrow_right
                                      : CupertinoIcons.cloud_upload,
                                  color: Colors.white,
                                )
                              : const LoadingSpinner(
                                  color: Colors.white,
                                  size: 20,
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
