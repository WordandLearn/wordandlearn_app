import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';

class SubscriptionInactiveWidget extends StatelessWidget {
  const SubscriptionInactiveWidget({
    super.key,
    this.isTrial = true,
  });
  final bool isTrial;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding * 2, vertical: defaultPadding),
            decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.all(defaultPadding / 2),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Icon(
                    CupertinoIcons.info,
                    color: isTrial ? null : Colors.red,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Column(
                    children: [
                      Text(
                        isTrial
                            ? "You are eligible for a 7 day free trial"
                            : "Your subscription is incomplete",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isTrial ? null : Colors.red),
                      ),
                      const SizedBox(
                        height: defaultPadding / 4,
                      ),
                      Text(
                        isTrial
                            ? "Enjoy WordandLearn for free with no extra hidden cost. Cancel at any time"
                            : "Complete your subscription to continue enjoying WordandLearn",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.greyTextColor),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TapBounce(
                    onTap: () {},
                    child: PrimaryButton(
                      color: AppColors.buttonColor,
                      child: Text(
                        isTrial ? "Start Free Trial" : "Complete Subscription",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
