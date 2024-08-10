import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';
import 'package:word_and_learn/views/payments/payment_page.dart';

class SubscriptionInactiveWidget extends StatefulWidget {
  const SubscriptionInactiveWidget({
    super.key,
    this.isTrial = true,
    required this.subscriptionPackage,
    required this.onStarted,
  });
  final bool isTrial;
  final SubscriptionPackage subscriptionPackage;
  final void Function() onStarted;

  @override
  State<SubscriptionInactiveWidget> createState() =>
      _SubscriptionInactiveWidgetState();
}

class _SubscriptionInactiveWidgetState
    extends State<SubscriptionInactiveWidget> {
  final WritingController _writingController = Get.find<WritingController>();
  bool loading = false;
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
                    color: widget.isTrial ? null : Colors.red,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Column(
                    children: [
                      Text(
                        widget.isTrial
                            ? "You are eligible for a 7 day free trial"
                            : "Your subscription is not active",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: widget.isTrial ? null : Colors.red),
                      ),
                      const SizedBox(
                        height: defaultPadding / 4,
                      ),
                      Text(
                        widget.isTrial
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
                    onTap: () {
                      if (!widget.isTrial) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) {
                                return PaymentPage(
                                    subscriptionPackage:
                                        widget.subscriptionPackage);
                              },
                              settings:
                                  const RouteSettings(name: "PaymentPage")),
                        );
                      } else {
                        // Call start free trial API
                        setState(() {
                          loading = true;
                        });
                        _writingController
                            .startTrial(widget.subscriptionPackage.id)
                            .then(
                          (value) {
                            if (value != null) {
                              widget.onStarted();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.check_mark_circled,
                                  ),
                                  SizedBox(
                                    width: defaultPadding,
                                  ),
                                  Text(
                                    "Trial started successfully",
                                    style: TextStyle(color: Colors.green),
                                  )
                                ],
                              )));
                            }
                          },
                        ).onError((error, stackTrace) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Row(
                            children: [
                              Icon(
                                CupertinoIcons.xmark_circle,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: defaultPadding,
                              ),
                              Text(
                                "Could not start trial",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          )));
                        }).whenComplete(
                          () {
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                      }
                    },
                    child: PrimaryButton(
                      color: AppColors.buttonColor,
                      child: loading
                          ? const LoadingSpinner(
                              size: 17,
                            )
                          : Text(
                              widget.isTrial
                                  ? "Start Free Trial"
                                  : "Complete Subscription",
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
