import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';
import 'package:word_and_learn/views/writing/settings/components/subscription_details_container.dart';
import 'package:word_and_learn/views/writing/settings/components/subscription_history_card.dart';

class SubscriptionSettings extends StatelessWidget {
  const SubscriptionSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.secondaryContainer,
        appBar: buildSettingsAppBar(context, title: "Manage Your Subscription"),
        body: ListView(children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding * 2),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                const SubscriptionDetailsContainer(),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: defaultPadding * 2, horizontal: defaultPadding),
                  child: Column(
                    children: [
                      _SubscriptionDetail(
                        title: "Price",
                        detail: "\$12.00",
                      ),
                      _SubscriptionDetail(
                        title: "Payment",
                        detail: "Monthly",
                      ),
                      _SubscriptionDetail(
                        title: "Start Subscription",
                        detail: "April 12, 2024",
                      ),
                      _SubscriptionDetail(
                        title: "Next Payment",
                        detail: "May 11, 2024",
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Row(
                    children: [
                      TapBounce(
                        onTap: () {},
                        child: PrimaryButton(
                          color: AppColors.redColor.withOpacity(0.4),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding / 2),
                            child: Text(
                              "Cancel Plan",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding * 2,
                      ),
                      Expanded(
                        child: TapBounce(
                          onTap: () {},
                          child: const PrimaryIconButton(
                              text: "Manage Plan",
                              icon: Icon(
                                CupertinoIcons.pen,
                                color: Colors.white,
                              )),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding * 2, horizontal: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "History",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return SubscriptionHistoryCard(
                        label: (index + 1).toString(),
                      );
                    })
              ],
            ),
          )
        ]));
  }
}

class _SubscriptionDetail extends StatelessWidget {
  const _SubscriptionDetail({
    super.key,
    required this.title,
    required this.detail,
  });

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 14,
                color: AppColors.inactiveColor,
                fontWeight: FontWeight.w600),
          ),
          Text(
            detail,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
