import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class MascotText extends StatelessWidget {
  const MascotText({super.key, required this.text, this.width, this.height});
  final String text;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset("assets/images/mascot_primary.png",
            width: width, height: height),
        const SizedBox(
          width: defaultPadding,
        ),
        Expanded(
            child: Bubble(
                style: const BubbleStyle(
                    color: Colors.transparent,
                    radius: Radius.circular(20),
                    borderColor: Color(0xFFE3E3E3),
                    nip: BubbleNip.leftCenter,
                    elevation: 0,
                    margin: BubbleEdges.only(bottom: defaultPadding),
                    alignment: Alignment.topLeft),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ))),
      ],
    );
  }
}
