import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

import 'primary_button.dart';

class PrimaryIconButton extends StatelessWidget {
  const PrimaryIconButton({super.key, required this.text, required this.icon});
  final String text;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      color: AppColors.buttonColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
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
            child: Center(child: icon),
          )
        ],
      ),
    );
  }
}
