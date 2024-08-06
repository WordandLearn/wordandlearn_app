import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';

class DangerModal extends StatelessWidget {
  const DangerModal(
      {super.key, required this.warning, required this.onProceed});
  final String warning;
  final void Function() onProceed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding * 2),
        child: Column(
          children: [
            Column(
              children: [
                const Text(
                  "Danger Zone",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Divider(
                  color: Colors.grey[200],
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "You might change your experience. Enter at Your own risk",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          height: 2,
                          color: AppColors.greyTextColor),
                    ),
                    Text(
                      warning,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          height: 1.5,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TapBounce(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.back),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Text("Go Back")
                    ],
                  ),
                ),
                TapBounce(
                    onTap: onProceed,
                    child: const PrimaryButton(
                        color: AppColors.buttonColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          child: Text(
                            "I Understand, Continue",
                            style: TextStyle(color: Colors.white),
                          ),
                        )))
              ],
            )
          ],
        ),
      ),
    );
  }
}
