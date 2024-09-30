import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Divider(
          color: AppColors.textColor.withOpacity(0.5),
          thickness: 1,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 1.5),
          color: Colors.white,
          child: Text(
            "OR",
            style: TextStyle(color: AppColors.textColor.withOpacity(0.5)),
          ),
        )
      ],
    );
  }
}
