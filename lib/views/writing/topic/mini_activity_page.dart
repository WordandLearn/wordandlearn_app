import 'package:flutter/material.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/writing/models.dart';

class MiniActivityPage extends StatelessWidget {
  const MiniActivityPage(
      {super.key,
      required this.miniActivity,
      this.colorModel,
      required this.onUnderstand});
  final MiniActivity miniActivity;
  final ColorModel? colorModel;
  final void Function() onUnderstand;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding * 2, vertical: defaultPadding * 2),
              decoration: BoxDecoration(
                  color: colorModel != null ? colorModel?.color : Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  const Text(
                    "Learning Activity",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text(
                                miniActivity.activityDescription,
                                style: const TextStyle(fontSize: 20, height: 2),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding),
                                child: miniActivity.activityText != null
                                    ? Text(
                                        miniActivity.activityText!,
                                        style: const TextStyle(
                                            fontSize: 18, height: 2),
                                      )
                                    : const SizedBox.shrink(),
                              )
                            ],
                          ),
                          const Spacer(),
                          Text(
                            miniActivity.criteria,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  TapBounce(
                      onTap: onUnderstand,
                      child: const PrimaryIconButton(
                          text: "I Understand",
                          // color: colorModel?.darkerColor,
                          icon: Icon(
                            Icons.done,
                            size: 17,
                            color: Colors.white,
                          )))
                ],
              ),
            )),
        Positioned(
          top: -40,
          left: 0,
          child: Image.asset(
            "assets/stickers/brain.png",
            height: 80,
          ),
        )
      ],
    );
  }
}
