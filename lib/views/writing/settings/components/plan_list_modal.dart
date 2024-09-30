import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/build_alert_dialog.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';
import 'package:word_and_learn/views/writing/settings/components/subscription_details_container.dart';

class PlanListModal extends StatefulWidget {
  const PlanListModal({
    super.key,
    this.userSubscription,
  });

  final UserSubscription? userSubscription;

  @override
  State<PlanListModal> createState() => _PlanListModalState();
}

class _PlanListModalState extends State<PlanListModal> {
  final WritingController _writingController = Get.find<WritingController>();
  late Future<List<SubscriptionPackage>?> subscriptionPackagesFuture;

  @override
  void initState() {
    subscriptionPackagesFuture = _writingController.getSubscriptionPackages();
    super.initState();
  }

  bool loading = false;

  SubscriptionPackage? selectedPackage;

  void initiateSubscription(BuildContext context) {
    context.loaderOverlay.show();
    _writingController.subscribeToPackage(selectedPackage!.id, {}).then(
      (value) async {
        if (value != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Redirecting to our payment gateway")));
          await launchUrl(Uri.parse(value["data"]["authorization_url"]));
        }
      },
    ).whenComplete(
      () {
        context.loaderOverlay.hide();
        if (context.mounted) {}
        setState(() {
          loading = false;
        });
      },
    );
  }

  void showChangePlanDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return buildAlertDialog(context,
              title: "Change Plan",
              content:
                  "Do you want to change your plan, additional costs may be incurred.\n\nYou will be redirected to our payment gateway.",
              button: loading
                  ? const LoadingSpinner(
                      size: 10,
                    )
                  : const Text("Change Plan",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600)), onPressed: () {
            setState(() {
              loading = true;
            });
            initiateSubscription(context);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<SubscriptionPackage>?>(
        future: subscriptionPackagesFuture,
        builder: (context, snapshot) {
          return Container(
            padding: allPadding,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            width: double.infinity,
            child: Column(
              children: [
                const Text(
                  "Select Your Plan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: defaultPadding * 2),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Builder(
                      key: ValueKey<bool>(snapshot.hasData),
                      builder: (context) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListView.builder(
                              itemCount: 1,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 200,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: defaultPadding),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                );
                              });
                        }

                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return SizedBox(
                            height: size.height * 0.4,
                            child: ListView.separated(
                              itemCount: snapshot.data!.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: defaultPadding * 2,
                              ),
                              itemBuilder: (context, index) {
                                SubscriptionPackage subscriptionPackage =
                                    snapshot.data![index];
                                return AnimatedScale(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                  scale: selectedPackage == subscriptionPackage
                                      ? 0.92
                                      : 0.9,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPackage = subscriptionPackage;
                                      });
                                    },
                                    child: SubscriptionDetailsContainer(
                                        subscriptionPackage:
                                            subscriptionPackage,
                                        active: selectedPackage ==
                                            subscriptionPackage,
                                        isRecommended:
                                            subscriptionPackage.interval ==
                                                    "monthly"
                                                ? true
                                                : false,
                                        subscriptionDetails:
                                            widget.userSubscription),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                          return const Text(
                              "No Subscription Packages Available");
                        }
                        return const Text("An Error Occurred");
                      },
                    ),
                  ),
                ),
                const Spacer(),
                TapBounce(
                  onTap: selectedPackage != null
                      ? () {
                          if (widget.userSubscription != null &&
                              widget.userSubscription!.subscription ==
                                  selectedPackage!) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Cannot change to this plan")));
                          } else {
                            showChangePlanDialog(context);
                          }
                          // Show confirmation alert dialog
                        }
                      : null,
                  child: PrimaryIconButton(
                      text: "Change Plan",
                      icon: loading
                          ? const LoadingSpinner(
                              size: 17,
                            )
                          : const Icon(
                              FeatherIcons.check,
                              color: Colors.white,
                              size: 17,
                            )),
                ),
              ],
            ),
          );
        });
  }
}
