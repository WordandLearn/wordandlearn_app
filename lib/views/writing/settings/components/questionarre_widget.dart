import 'package:flutter/material.dart';
import 'package:word_and_learn/components/auth_text_field.dart';
import 'package:word_and_learn/constants/colors.dart';
import 'package:word_and_learn/constants/constants.dart';

import 'radio_input.dart';

class QuestionarreWidget extends StatefulWidget {
  const QuestionarreWidget({
    super.key,
    required this.title,
    required this.questions,
    required this.subTitle,
    required this.onPressed,
    this.activeReason,
  });

  final String title;
  final String subTitle;
  final List<String> questions;
  final void Function(String answer) onPressed;
  final String? activeReason;

  @override
  State<QuestionarreWidget> createState() => _QuestionarreWidgetState();
}

class _QuestionarreWidgetState extends State<QuestionarreWidget> {
  String? value;
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Text(widget.subTitle,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.greyTextColor)),
          const SizedBox(
            height: defaultPadding,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          ...widget.questions.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: InkWell(
                  onTap: () {
                    setState(() {
                      value = e;
                    });
                    widget.onPressed(e);
                  },
                  child: RadioInput(
                    label: e,
                    isActive: widget.activeReason == e ||
                        e == "Other" && widget.questions.contains(value),
                  )),
            ),
          ),
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: AuthTextField(
                  hintText: "Other Reason",
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 14),
                  fillColor: AppColors.secondaryContainer,
                  maxLines: 2,
                  onChanged: (p0) {
                    widget.onPressed(p0);
                  },
                ),
              ))
        ],
      ),
    );
  }
}
