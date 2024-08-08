import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/payments/package_subscription_details.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';
import 'package:word_and_learn/views/writing/settings/components/questionarre_widget.dart';
import 'package:word_and_learn/views/writing/settings/components/radio_input.dart';
import 'package:word_and_learn/views/writing/settings/components/subscription_details_container.dart';

class SubscriptionManageBottomSheet extends StatefulWidget {
  const SubscriptionManageBottomSheet({
    super.key,
    required this.packageSubscriptionDetails,
  });

  final PackageSubscriptionDetails packageSubscriptionDetails;

  @override
  State<SubscriptionManageBottomSheet> createState() =>
      _SubscriptionManageBottomSheetState();
}

class _SubscriptionManageBottomSheetState
    extends State<SubscriptionManageBottomSheet> {
  @override
  Widget build(BuildContext context) {
    SubscriptionPackage subscriptionPackage = widget
            .packageSubscriptionDetails.isTrial
        ? widget.packageSubscriptionDetails.trialDetails!.subscription
        : widget.packageSubscriptionDetails.subscriptionDetails!.subscription;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding * 2, vertical: defaultPadding * 2),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            const Text(
              "Manage Your Subscription",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Divider(
              color: Colors.grey[300]!,
            ),
            const Spacer(
              flex: 1,
            ),
            SubscriptionDetailsContainer(
              subscriptionDetails:
                  widget.packageSubscriptionDetails.subscriptionDetails,
              trialDetails: widget.packageSubscriptionDetails.trialDetails,
              subscriptionPackage: subscriptionPackage,
            ),
            const Spacer(
              flex: 2,
            ),
            TapBounce(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return CancelAlertDialog(
                        subscriptionPackage: subscriptionPackage,
                      );
                    });
              },
              child: PrimaryIconButton(
                  color: Colors.red.withOpacity(0.8),
                  text: "Cancel Subscription",
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 17,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class CancelAlertDialog extends StatefulWidget {
  const CancelAlertDialog({super.key, required this.subscriptionPackage});
  final SubscriptionPackage subscriptionPackage;
  @override
  State<CancelAlertDialog> createState() => _CancelAlertDialogState();
}

class _CancelAlertDialogState extends State<CancelAlertDialog> {
  final WritingController _writingController = Get.find<WritingController>();
  String? cancelReason;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: AlertDialog(
        backgroundColor: Colors.white,
        scrollable: true,
        title: const Text(
          "Cancel Subscription",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        content: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: !loading
              ? QuestionarreWidget(
                  title: "Why are you cancelling?",
                  subTitle:
                      "Please let us know why you are cancelling, so that we can improve our services",
                  questions: const [
                    "I don't find the service useful",
                    "I can't afford the subscription",
                    "I have found a better alternative",
                    "I am not satisfied with the service",
                  ],
                  activeReason: cancelReason,
                  onPressed: (answer) {
                    setState(() {
                      cancelReason = answer;
                    });
                  },
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(vertical: defaultPadding),
                  child: LoadingSpinner(
                    color: AppColors.buttonColor,
                  ),
                ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Not yet",
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  onPressed: () {
                    if (cancelReason != null && cancelReason!.isNotEmpty) {
                      //TODO: Push Cancel Reasons To Firebae
                      setState(() {
                        loading = true;
                      });
                      _writingController
                          .cancelSubscription(widget.subscriptionPackage.id)
                          .then(
                        (value) {
                          if (value != null) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content: Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                                Text(
                                  "Subscription cancelled",
                                  style: TextStyle(color: Colors.green),
                                )
                              ],
                            )));
                          }
                        },
                      ).onError(
                        (error, stackTrace) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Row(
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: defaultPadding,
                              ),
                              Text(
                                "Could not cancel your subscription",
                                style: TextStyle(color: Colors.green),
                              )
                            ],
                          )));
                        },
                      ).whenComplete(
                        () {
                          setState(() {
                            loading = false;
                          });
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                        "Select a reason to continue",
                        style: TextStyle(color: Colors.red),
                      )));
                    }
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: !loading
                        ? Text(
                            "Proceed To Cancel",
                            style: TextStyle(
                                color: cancelReason != null &&
                                        cancelReason!.isNotEmpty
                                    ? Colors.red
                                    : AppColors.inactiveColor,
                                fontWeight: FontWeight.w600),
                          )
                        : const LoadingSpinner(),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
