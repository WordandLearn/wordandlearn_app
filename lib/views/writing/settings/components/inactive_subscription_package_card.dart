// ignore_for_file: deprecated_member_use

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/payments/subscription_package.dart';

class InactiveSubscriptionPackageCard extends StatelessWidget {
  const InactiveSubscriptionPackageCard(
      {super.key, required this.subscriptionPackage, this.active = true});

  final SubscriptionPackage subscriptionPackage;

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 300),
      scale: active ? 1.0 : 0.98,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: 200,
        decoration: BoxDecoration(
          color: active
              ? subscriptionPackage.darkerColor
              : subscriptionPackage.colorValue,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.01),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: active
              ? Border.all(
                  color: active
                      ? AppColors.buttonColor
                      : AppColors.secondaryContainer,
                  width: 1.5)
              : null,
        ),
        child: Column(
          children: [
            subscriptionPackage.recommended
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding / 4),
                    decoration: const BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/diamond.svg",
                          width: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: defaultPadding / 2,
                        ),
                        const Text(
                          "Recommended",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: allPadding * 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding * 2,
                                  vertical: defaultPadding) /
                              2,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            StringUtils.capitalize(
                                subscriptionPackage.interval),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          )),
                      const Spacer(),
                      Container(
                        width: 20,
                        height: 20,
                        padding: allPadding / 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: active
                              ? null
                              : Border.all(color: Colors.grey, width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: active
                            ? Center(
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: active
                                        ? subscriptionPackage.darkerColor
                                        : AppColors.inactiveColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Text(
                        "${subscriptionPackage.currency} ${subscriptionPackage.price}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor)),
                  ),
                  Column(
                      children: subscriptionPackage.constraints.map((e) {
                    return RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "${e.value} Compositions",
                          style: GoogleFonts.fredoka(
                              fontSize: 14, color: AppColors.textColor)),
                      TextSpan(
                          text: " / ${subscriptionPackage.intervalAsNoun}",
                          style: GoogleFonts.fredoka(
                              color: Colors.grey, fontSize: 14)),
                    ]));
                  }).toList())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
