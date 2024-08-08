import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/payments/package_subscription_details.dart';

import 'subscription_manage_bottomsheet.dart';

class SubscriptionActiveWidget extends StatelessWidget {
  const SubscriptionActiveWidget(
      {super.key, required this.packageSubscriptionDetails});
  final PackageSubscriptionDetails packageSubscriptionDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding * 2),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TapBounce(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 400,
                          child: SubscriptionManageBottomSheet(
                            packageSubscriptionDetails:
                                packageSubscriptionDetails,
                          ),
                        );
                      },
                    );
                  },
                  child: PrimaryIconButton(
                      text: packageSubscriptionDetails.isTrial
                          ? "Manage Trial"
                          : "Manage Subscription",
                      icon: const Icon(
                        CupertinoIcons.pen,
                        color: Colors.white,
                        size: 17,
                      )),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
