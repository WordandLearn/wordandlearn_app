// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';
import 'package:word_and_learn/views/writing/settings/components/cancel_alert_dialog.dart';
import 'package:word_and_learn/views/writing/settings/components/payment_history_list.dart';
import 'package:word_and_learn/views/writing/settings/components/plan_list_modal.dart';
import 'package:word_and_learn/views/writing/settings/components/subscription_details_container.dart';
import 'package:word_and_learn/views/writing/settings/components/subscription_inactive_widget.dart';

import '../../../models/payments/payment_models.dart';

class SubscriptionSettings extends StatefulWidget {
  const SubscriptionSettings({super.key});

  @override
  State<SubscriptionSettings> createState() => _SubscriptionSettingsState();
}

class _SubscriptionSettingsState extends State<SubscriptionSettings> {
  late Future<List<UserSubscription>?> userSubscriptionFuture;
  final WritingController _writingController = Get.find<WritingController>();
  @override
  void initState() {
    userSubscriptionFuture = _writingController.getUserSubscription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildSettingsAppBar(context,
            title: "Your Subscription", actions: []),
        body: ListView(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  FutureBuilder<List<UserSubscription>?>(
                      future: userSubscriptionFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return const SubscriptionInactiveWidget();
                          }
                          return SizedBox(
                            height: size.height * 0.85,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding,
                                  vertical: defaultPadding),
                              child: Column(
                                children: [
                                  SubscriptionDetailsContainer(
                                      subscriptionDetails: snapshot.data?.first,
                                      subscriptionPackage:
                                          snapshot.data![0].subscription),
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                  snapshot.hasData && snapshot.data!.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: defaultPadding),
                                          child: Row(
                                            children: [
                                              _PaymentDateWidget(
                                                label: "Last Payment",
                                                date: DateFormat.yMMMMd()
                                                    .format(snapshot.data?.first
                                                            .updatedAt ??
                                                        DateTime.now()),
                                                icon: const Icon(
                                                  FeatherIcons.clock,
                                                  color:
                                                      AppColors.inactiveColor,
                                                  size: 16,
                                                ),
                                              ),
                                              const Spacer(),
                                              _PaymentDateWidget(
                                                label: "Next Payment",
                                                date: DateFormat.yMMMMd()
                                                    .format(snapshot.data?.first
                                                            .endDate ??
                                                        DateTime.now()),
                                                icon: const Icon(
                                                  FeatherIcons.calendar,
                                                  color:
                                                      AppColors.inactiveColor,
                                                  size: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: defaultPadding * 3),
                                    child: PaymentHistoryList(),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: TapBounce(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return SizedBox(
                                                    height: size.height * 0.6,
                                                    child: PlanListModal(
                                                      userSubscription:
                                                          snapshot.data?.first,
                                                    ));
                                              });
                                        },
                                        child: PrimaryIconButton(
                                            text: "Change Plan",
                                            icon: SvgPicture.asset(
                                              "assets/icons/exchange.svg",
                                              width: 15,
                                              color: Colors.white,
                                            )),
                                      )),
                                      const SizedBox(
                                        width: defaultPadding,
                                      ),
                                      TapBounce(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return const CancelAlertDialog();
                                              });
                                        },
                                        child: Container(
                                            padding: allPadding * 1.25,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  FeatherIcons.trash,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: defaultPadding / 2,
                                                ),
                                                Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            )),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }

                        return const LoadingSpinner();
                      }),
                ],
              ),
            ),
          ],
        ));
  }
}

class _PaymentDateWidget extends StatelessWidget {
  const _PaymentDateWidget({
    required this.label,
    required this.date,
    required this.icon,
  });
  final String label;
  final String date;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding * 1.5, vertical: defaultPadding),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.secondaryColor),
            boxShadow: const [
              // BoxShadow(
              //     color: Colors.grey.withOpacity(0.1),
              //     blurRadius: 10,
              //     offset: const Offset(0, 5))
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(
              width: defaultPadding,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.inactiveColor,
                  fontSize: 12,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ]),
          ],
        ));
  }
}
