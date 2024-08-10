import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';
import 'package:word_and_learn/views/writing/settings/components/payment_history_list.dart';
import 'package:word_and_learn/views/writing/settings/components/subscription_details_container.dart';
import 'package:word_and_learn/views/writing/settings/components/subscription_inactive_widget.dart';

import 'components/subscription_active_widget.dart';

class SubscriptionSettings extends StatefulWidget {
  const SubscriptionSettings({super.key});

  @override
  State<SubscriptionSettings> createState() => _SubscriptionSettingsState();
}

class _SubscriptionSettingsState extends State<SubscriptionSettings> {
  late Future<List<SubscriptionPackage>?> packagesFuture;
  @override
  void initState() {
    packagesFuture = _writingController.getSubscriptionPackages();
    super.initState();
  }

  final WritingController _writingController = Get.find<WritingController>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.secondaryContainer,
        appBar: buildSettingsAppBar(context, title: "Your Subscription"),
        body: ListView(children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: size.height * 0.4),
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding * 2),
              decoration: const BoxDecoration(color: Colors.white),
              child: FutureBuilder<List<SubscriptionPackage>?>(
                  future: packagesFuture,
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data!.isNotEmpty
                        ? _SubscriptionPackagesWidget(
                            package: snapshot.data!.first)
                        : const LoadingSpinner();
                  }),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
                vertical: defaultPadding * 2, horizontal: defaultPadding),
            child: PaymentHistoryList(),
          )
        ]));
  }
}

class _SubscriptionPackagesWidget extends StatefulWidget {
  const _SubscriptionPackagesWidget({
    required this.package,
  });
  final SubscriptionPackage package;

  @override
  State<_SubscriptionPackagesWidget> createState() =>
      _SubscriptionPackagesWidgetState();
}

class _SubscriptionPackagesWidgetState
    extends State<_SubscriptionPackagesWidget> {
  final WritingController _writingController = Get.find<WritingController>();
  late Future<PackageSubscriptionDetails?> _future;

  @override
  void initState() {
    _future =
        _writingController.getPackageSubscriptionDetails(widget.package.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageSubscriptionDetails?>(
        future: _future,
        builder: (context, snapshot) {
          // print(snapshot.error);
          // print(snapshot.stackTrace);
          return Column(
            children: [
              //Fetch Subscription from API
              SubscriptionDetailsContainer(
                subscriptionPackage: widget.package,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding * 2, horizontal: defaultPadding),
                child: snapshot.hasData
                    ? Column(
                        children: [
                          snapshot.data!.active
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: defaultPadding),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            color: snapshot.data!.isTrial
                                                ? Colors.green
                                                : snapshot
                                                        .data!
                                                        .subscriptionDetails!
                                                        .cancelled
                                                    ? Colors.red
                                                    : Colors.blue,
                                            shape: BoxShape.circle),
                                      ),
                                      const SizedBox(
                                        width: defaultPadding / 2,
                                      ),
                                      Text(
                                        snapshot.data!.isTrial
                                            ? "Trial in Progress"
                                            : snapshot
                                                    .data!
                                                    .subscriptionDetails!
                                                    .cancelled
                                                ? "Subscription Cancelled"
                                                : "Subscription Active",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: snapshot.data!.isTrial
                                                ? Colors.green
                                                : snapshot
                                                        .data!
                                                        .subscriptionDetails!
                                                        .cancelled
                                                    ? Colors.red
                                                    : Colors.blue),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          Builder(builder: (context) {
                            PackageSubscriptionDetails
                                packageSubscriptionDetails = snapshot.data!;

                            if (!packageSubscriptionDetails.active) {
                              // Handle not active, either start a trial or initiate subscription
                              if (packageSubscriptionDetails.trialEligible) {
                                return SubscriptionInactiveWidget(
                                  subscriptionPackage: widget.package,
                                  onStarted: () {
                                    setState(() {
                                      _future = _writingController
                                          .getPackageSubscriptionDetails(
                                              widget.package.id);
                                    });
                                  },
                                  isTrial: true,
                                );
                              } else {
                                return SubscriptionInactiveWidget(
                                  isTrial: false,
                                  subscriptionPackage: widget.package,
                                  onStarted: () {
                                    setState(() {
                                      _future = _writingController
                                          .getPackageSubscriptionDetails(
                                              widget.package.id);
                                    });
                                  },
                                );
                              }
                            } else {
                              if (packageSubscriptionDetails
                                          .subscriptionDetails !=
                                      null ||
                                  packageSubscriptionDetails.trialDetails !=
                                      null) {
                                return Column(
                                  children: [
                                    Column(
                                      children: [
                                        _SubscriptionDetail(
                                          title: "Price",
                                          detail: "KES ${widget.package.price}",
                                        ),
                                        _SubscriptionDetail(
                                          title: "Payment",
                                          detail: widget.package.isYearly
                                              ? "Yearly"
                                              : "Monthly",
                                        ),
                                        _SubscriptionDetail(
                                          title:
                                              packageSubscriptionDetails.isTrial
                                                  ? "Trial Start Date"
                                                  : "Start Subscription",
                                          detail:
                                              packageSubscriptionDetails.isTrial
                                                  ? packageSubscriptionDetails
                                                      .trialDetails!
                                                      .createdAtFormatted
                                                  : packageSubscriptionDetails
                                                      .subscriptionDetails!
                                                      .paidAtFormatted,
                                        ),
                                        _SubscriptionDetail(
                                          title:
                                              packageSubscriptionDetails.isTrial
                                                  ? "Trial Ends Date"
                                                  : "Next Payment Date",
                                          detail: packageSubscriptionDetails
                                                  .isTrial
                                              ? packageSubscriptionDetails
                                                  .trialDetails!
                                                  .endDateFormatted
                                              : packageSubscriptionDetails
                                                      .subscriptionDetails!
                                                      .cancelled
                                                  ? "N/A"
                                                  : packageSubscriptionDetails
                                                      .subscriptionDetails!
                                                      .endDateFormatted,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: defaultPadding,
                                    ),
                                    SubscriptionActiveWidget(
                                      packageSubscriptionDetails:
                                          packageSubscriptionDetails,
                                    )
                                  ],
                                );
                              }
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      )
                    : const LoadingSpinner(),
              ),
              const SizedBox(
                height: defaultPadding,
              ),
            ],
          );
        });
  }
}

class _SubscriptionDetail extends StatelessWidget {
  const _SubscriptionDetail({
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
                fontWeight: FontWeight.w500),
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
