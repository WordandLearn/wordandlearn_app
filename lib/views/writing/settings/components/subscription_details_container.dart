import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class SubscriptionDetailsContainer extends StatelessWidget {
  const SubscriptionDetailsContainer({
    super.key,
  });

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
                  AppColors.primaryColor,
                  AppColors.secondaryColor,
                  AppColors.greenColor,
                ], stops: [
                  0.1,
                  0.8,
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
                    const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            // Text(
                            //   "",
                            //   style: TextStyle(
                            //       fontSize: 14,
                            //       color: AppColors.greyTextColor,
                            //       fontWeight: FontWeight.w500),
                            // ),
                            Text(
                              "April 15th 2024",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greyTextColor),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: defaultPadding / 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$12.00",
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: defaultPadding / 4,
                                  ),
                                  Text(
                                    "Paid",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Writing Package",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Monthly",
                              style: TextStyle(
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
