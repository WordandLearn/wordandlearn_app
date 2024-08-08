import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';

class SubscriptionDetailsContainer extends StatelessWidget {
  const SubscriptionDetailsContainer({
    super.key,
    this.subscriptionDetails,
    this.trialDetails,
    required this.subscriptionPackage,
  });

  final SubscriptionDetails? subscriptionDetails;
  final TrialDetails? trialDetails;
  final SubscriptionPackage subscriptionPackage;

  // final String? dueDate;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 190,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                    vertical: defaultPadding / 2,
                    horizontal: defaultPadding / 2),
                // color: Colors.blue
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.white,
                  AppColors.primaryColor,
                  AppColors.secondaryColor,
                ], stops: [
                  0.1,
                  0.4,
                  0.9
                ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding * 2,
                    vertical: defaultPadding * 2),
                constraints: const BoxConstraints(minHeight: 140),
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(3, 10),
                          spreadRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          const EdgeInsetsDirectional.all(defaultPadding / 2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2))),
                      child: Image.asset(
                        "assets/logo/Logotype.png",
                        width: 40,
                        height: 40,
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            // Text(
                            //   "",
                            //   style: TextStyle(
                            //       fontSize: 14,
                            //       color: AppColors.greyTextColor,
                            //       fontWeight: FontWeight.w500),
                            // ),
                            Text(
                              subscriptionDetails != null
                                  ? subscriptionDetails!.paidAtFormatted
                                  : "",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greyTextColor),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding / 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "KES ${subscriptionPackage.price}",
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              subscriptionDetails != null
                                  ? Row(
                                      children: [
                                        subscriptionDetails!.cancelled
                                            ? const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              )
                                            : subscriptionDetails!.isPaid
                                                ? const Icon(
                                                    Icons.done,
                                                    color: Colors.green,
                                                  )
                                                : const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  ),
                                        const SizedBox(
                                          width: defaultPadding / 4,
                                        ),
                                        subscriptionDetails!.cancelled
                                            ? const Text(
                                                "Cancelled",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            : subscriptionDetails!.isPaid
                                                ? const Text(
                                                    "Paid",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                : const Text(
                                                    "Not Paid",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                      ],
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              subscriptionPackage.name,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              subscriptionPackage.isYearly
                                  ? "Yearly"
                                  : "Monthly",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
