import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/build_alert_dialog.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/components/or_divider.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';
import 'package:word_and_learn/utils/color_utils.dart';
import 'package:word_and_learn/utils/exceptions.dart';
import 'package:word_and_learn/views/writing/lessons/lessons_page.dart';

import 'inactive_subscription_package_card.dart';

class SubscriptionInactivePage extends StatelessWidget {
  const SubscriptionInactivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: SubscriptionInactiveWidget()),
    );
  }
}

class SubscriptionInactiveWidget extends StatefulWidget {
  const SubscriptionInactiveWidget({super.key});

  @override
  State<SubscriptionInactiveWidget> createState() =>
      _SubscriptionInactiveWidgetState();
}

class _SubscriptionInactiveWidgetState
    extends State<SubscriptionInactiveWidget> {
  final WritingController _writingController = Get.find<WritingController>();
  late Future<List<SubscriptionPackage>?> _subscriptionPackagesFuture;

  @override
  void initState() {
    _subscriptionPackagesFuture = _writingController.getSubscriptionPackages();
    super.initState();
  }

  SubscriptionPackage? selectedSubscriptionPackage;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: defaultPadding, horizontal: defaultPadding),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Subscription",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: defaultPadding),
                          child: Text(
                            "To use WordandLearn and enjoy a redefined writing experience, you need to subscribe to a plan.",
                            style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: AppColors.textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: defaultPadding),
                        child: Text(
                          "Choose a Plan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 190,
                        child: FutureBuilder<List<SubscriptionPackage>?>(
                            future: _subscriptionPackagesFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 200,
                                          height: 180,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          width: defaultPadding,
                                        ),
                                    itemCount: 2);
                              }
                              if (snapshot.hasData) {
                                return ListView.separated(
                                    itemCount: snapshot.data!.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          width: defaultPadding,
                                        ),
                                    itemBuilder: (context, index) {
                                      SubscriptionPackage subscriptionPackage =
                                          snapshot.data![index];
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedSubscriptionPackage =
                                                subscriptionPackage;
                                          });
                                        },
                                        child: InactiveSubscriptionPackageCard(
                                            active:
                                                selectedSubscriptionPackage ==
                                                    subscriptionPackage,
                                            subscriptionPackage:
                                                subscriptionPackage),
                                      );
                                    });
                              }
                              return const SizedBox();
                            }),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      const Column(
                        children: [
                          InactiveBenefitCard(
                            assetUrl: "assets/stickers/learning_sticker.png",
                            title: "A Personalized Writing Experience",
                            description:
                                "Lessons made just for your child based on their writing & progress",
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: defaultPadding * 2),
                            child: InactiveBenefitCard(
                              assetUrl: "assets/stickers/hybrid_sticker.png",
                              title: "Embrace Hybrid Learning & Insights",
                              description:
                                  "Your child doesn't have to be on the phone at all times, exercises are pen and paper based",
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                children: [
                  TapBounce(
                    onTap: () {
                      if (selectedSubscriptionPackage == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Please select a subscription package"),
                          backgroundColor: Colors.red,
                        ));
                      } else {
                        context.loaderOverlay.show();
                        setState(() {
                          loading = true;
                        });
                        _writingController.subscribeToPackage(
                            selectedSubscriptionPackage!.id, {}).then(
                          (value) async {
                            if (value != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Redirecting to our payment gateway")));
                              await launchUrl(Uri.parse(
                                  value["data"]["authorization_url"]));
                            }
                          },
                        ).onError(
                          (error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "An error occurred while trying to subscribe to the package"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                        ).whenComplete(
                          () {
                            context.loaderOverlay.hide();
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                      }
                    },
                    child: PrimaryIconButton(
                        text: "Proceed To Payment",
                        color: selectedSubscriptionPackage != null
                            ? AppColors.buttonColor
                            : AppColors.inactiveColor,
                        icon: loading
                            ? const LoadingSpinner(
                                size: 17,
                              )
                            : const Icon(
                                FeatherIcons.arrowRight,
                                size: 17,
                                color: Colors.white,
                              )),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding),
                    child: OrDivider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return buildAlertDialog(
                              context,
                              title: "Free Trial",
                              content:
                                  "The free trial only allows you to upload 1 composition and get 1 lesson only.",
                              onPressed: () {
                                context.loaderOverlay.show();
                                _writingController.startTrial().then(
                                  (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "You have successfully started the free trial"),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LessonsPage(),
                                        settings: const RouteSettings(
                                            name: "LessonsPage"),
                                      ),
                                    );
                                  },
                                ).onError(
                                  (error, stackTrace) {
                                    if (error is HttpFetchException) {
                                      if (error.statusCode == 403) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "You have already started the free trial"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "An error occurred while trying to start the free trial"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ).whenComplete(
                                  () {
                                    context.loaderOverlay.hide();
                                  },
                                );
                              },
                              button: const Row(
                                children: [
                                  Text(
                                    "Start Free Trial",
                                    style: TextStyle(
                                        color: AppColors.buttonColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: defaultPadding,
                                  ),
                                  Icon(
                                    FeatherIcons.arrowRight,
                                    size: 17,
                                    color: AppColors.buttonColor,
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Text(
                        "Start Free Trial",
                        style: TextStyle(
                            color: AppColors.buttonColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InactiveBenefitCard extends StatelessWidget {
  const InactiveBenefitCard({
    super.key,
    required this.assetUrl,
    required this.title,
    required this.description,
  });

  final String assetUrl, title, description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: defaultPadding, horizontal: defaultPadding * 1.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorUtils.randomHueFromColor(color: AppColors.primaryColor)
              .withOpacity(0.05)),
      child: Row(
        children: [
          Image.asset(
            assetUrl,
            width: 35,
            height: 35,
          ),
          const SizedBox(
            width: defaultPadding,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: defaultPadding / 4,
                ),
                Text(
                  description,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF3F4861)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
