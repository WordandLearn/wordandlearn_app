import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';
import 'package:word_and_learn/utils/color_utils.dart';
import 'package:word_and_learn/utils/sticker_utils.dart';

class SubscriptionDetailsContainer extends StatelessWidget {
  const SubscriptionDetailsContainer(
      {super.key,
      required this.subscriptionPackage,
      this.subscriptionDetails,
      this.active = false,
      this.isRecommended = false});

  final SubscriptionPackage subscriptionPackage;
  final UserSubscription? subscriptionDetails;
  final bool isRecommended;
  final bool active;

  // final String? dueDate;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 180,
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
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.white,
                  ColorUtils.randomHueFromColor(color: AppColors.primaryColor),
                  ColorUtils.randomHueFromColor(
                      color: AppColors.secondaryColor),
                ], stops: const [
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
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: !active
                            ? Colors.grey.withOpacity(0.2)
                            : AppColors.buttonColor,
                        width: active ? 2 : 1),
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
                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsetsDirectional.all(
                                  defaultPadding / 2),
                              decoration: BoxDecoration(
                                  color: ColorUtils.randomHueFromColor(
                                          color: AppColors.primaryColor)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.2))),
                            ),
                            Positioned(
                              top: -10,
                              child: Image.asset(
                                StickerUtils.getRandomSticker(),
                                width: 40,
                                height: 40,
                              ),
                            ),
                            isRecommended
                                ? Positioned(
                                    right: -140,
                                    top: -10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: defaultPadding,
                                          vertical: defaultPadding / 2),
                                      decoration: BoxDecoration(
                                          color: AppColors.buttonColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/diamond.svg",
                                            width: 18,
                                            // ignore: deprecated_member_use
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: defaultPadding / 2,
                                          ),
                                          const Text(
                                            "Recommended",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        const Spacer(),
                        subscriptionDetails != null &&
                                subscriptionDetails?.subscription ==
                                    subscriptionPackage
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding / 2,
                                    vertical: defaultPadding / 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: subscriptionDetails!.isPaid
                                            ? Colors.green.withOpacity(0.5)
                                            : AppColors.inactiveColor),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  subscriptionDetails!.isPaid
                                      ? "Active"
                                      : "Inactive",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: subscriptionDetails!.isPaid
                                          ? Colors.green
                                          : AppColors.inactiveColor),
                                ))
                            : const SizedBox.shrink()
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding / 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "KES ${subscriptionPackage.price}",
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
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
                              subscriptionPackage.interval.toUpperCase(),
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
