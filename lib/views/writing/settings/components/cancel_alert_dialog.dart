import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/writing/settings/components/questionarre_widget.dart';

class CancelAlertDialog extends StatefulWidget {
  const CancelAlertDialog({
    super.key,
  });
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
                      setState(() {
                        loading = true;
                      });
                      _writingController.cancelSubscription().then(
                        (value) async {
                          if (value != null) {
                            Profile? childProfile =
                                await _writingController.getChildProfile();
                            Map<String, dynamic> firestoreCancelBody = {
                              "profile": childProfile?.toJson(),
                              "module": "W",
                              "reason": cancelReason,
                            };

                            FirebaseFirestore firestore =
                                FirebaseFirestore.instance;
                            firestore
                                .collection("subscription_cancellations")
                                .doc()
                                .set(firestoreCancelBody);

                            if (context.mounted) {
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
