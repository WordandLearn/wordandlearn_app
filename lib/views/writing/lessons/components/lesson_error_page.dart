import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/loading_spinner.dart';
import 'package:word_and_learn/components/primary_icon_button.dart';
import 'package:word_and_learn/constants/constants.dart';

class LessonErrorPage extends StatelessWidget {
  const LessonErrorPage(
      {super.key,
      required this.errorTitle,
      required this.errorText,
      this.assetUrl,
      this.action});

  final String errorTitle;
  final String errorText;

  final String? assetUrl;

  final Widget? action;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          assetUrl ?? "assets/illustrations/kids-reading.png",
          height: size.height * 0.25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Text(
                  errorTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Text(
                    errorText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textColor),
                  ))
            ],
          ),
        ),
        action != null
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: action,
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
