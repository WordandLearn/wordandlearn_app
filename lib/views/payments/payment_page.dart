import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';
import 'package:word_and_learn/views/writing/settings/components/subscription_details_container.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.subscriptionPackage});

  final SubscriptionPackage subscriptionPackage;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool loading = false;
  final TextEditingController firstNameTextController = TextEditingController();
  final TextEditingController lastTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController cityTextController = TextEditingController();
  final TextEditingController zipCodeTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final WritingController _writingController = Get.find<WritingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSettingsAppBar(context, title: "Complete Subscription"),
      body: ListView(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding),
        children: [
          Hero(
              tag: "subscription_details_container",
              child: SubscriptionDetailsContainer(
                  subscriptionPackage: widget.subscriptionPackage)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Billing Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2,
                      vertical: defaultPadding * 2),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: BillingInputField(
                              label: "First Name",
                              hintText: "Example: John",
                              controller: firstNameTextController,
                              validator: (value) {
                                if (value == null) {
                                  return "*Required";
                                }

                                if (value.isEmpty) {
                                  return "*Required";
                                }
                                return null;
                              },
                            )),
                            const SizedBox(
                              width: defaultPadding * 2,
                            ),
                            Expanded(
                                child: BillingInputField(
                                    label: "Last Name",
                                    hintText: "Example: Doe",
                                    controller: lastTextController,
                                    validator: (value) {
                                      if (value == null) {
                                        return "*Required";
                                      }

                                      if (value.isEmpty) {
                                        return "*Required";
                                      }
                                      return null;
                                    })),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 2),
                          child: BillingInputField(
                              label: "Email Address",
                              hintText: "xxx@xxx.com",
                              textInputType: TextInputType.emailAddress,
                              controller: emailTextController,
                              validator: (value) {
                                if (value == null) {
                                  return "*Required";
                                }

                                if (value.isEmpty) {
                                  return "*Required";
                                }
                                if (!value.isEmail) {
                                  return "*Enter a valid email address";
                                }
                                return null;
                              }),
                        ),
                        BillingInputField(
                            label: "Phone Number",
                            hintText: "07xxxxxxxx",
                            textInputType: TextInputType.phone,
                            controller: phoneTextController,
                            validator: (value) {
                              if (value == null) {
                                return "*Required";
                              }

                              if (value.isEmpty) {
                                return "*Required";
                              }
                              if (!value.isNumericOnly) {
                                return "Enter a valid phone number";
                              }
                              if (!value.startsWith("07") &&
                                  !value.startsWith("01")) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            }),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 2),
                          child: Row(
                            children: [
                              Expanded(
                                child: BillingInputField(
                                    label: "City",
                                    hintText: "Nairobi",
                                    controller: cityTextController,
                                    validator: (value) {
                                      if (value == null) {
                                        return "*Required";
                                      }

                                      if (value.isEmpty) {
                                        return "*Required";
                                      }
                                      return null;
                                    }),
                              ),
                              const SizedBox(
                                width: defaultPadding * 2,
                              ),
                              Expanded(
                                child: BillingInputField(
                                    label: "Zip Code",
                                    hintText: "00100",
                                    controller: zipCodeTextController,
                                    textInputType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null) {
                                        return "*Required";
                                      }

                                      if (value.isEmpty) {
                                        return "*Required";
                                      }

                                      if (!value.isNumericOnly) {
                                        return "*Enter a valid zipcode";
                                      }
                                      return null;
                                    }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Text(
                  "* You will be redirected to our payment gateway, Pesapal , to complete your payment",
                  style: TextStyle(color: AppColors.greyTextColor),
                ),
                const SizedBox(
                  height: defaultPadding * 4,
                ),
                TapBounce(
                  onTap: () {
                    if (!loading) {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        Map<String, String> body = {
                          "first_name": firstNameTextController.text,
                          "last_name": lastTextController.text,
                          "email_address": emailTextController.text,
                          "phone_number": phoneTextController.text,
                          "zip_code": zipCodeTextController.text,
                          "city": cityTextController.text,
                          "country_code": "KE",
                        };
                        _writingController
                            .subscribeToPackage(
                                widget.subscriptionPackage.id, body)
                            .then(
                          (value) async {
                            if (value != null) {
                              try {
                                await launchUrl(Uri.parse(
                                    value['data']['authorization_url']));
                              } on Exception {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Row(
                                    children: [
                                      Icon(Icons.info, color: Colors.red),
                                      SizedBox(
                                        width: defaultPadding,
                                      ),
                                      Text("Could not open browser")
                                    ],
                                  )));
                                }
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
                                  Icons.info,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                                Text("Could not contact payment gateway")
                              ],
                            )));
                          },
                        ).whenComplete(
                          () {
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                      }
                    }
                  },
                  child: PrimaryIconButton(
                      text: "Proceed To Payment",
                      icon: loading
                          ? const LoadingSpinner(
                              size: 15,
                            )
                          : const Icon(
                              CupertinoIcons.arrow_right,
                              size: 17,
                              color: Colors.white,
                            )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BillingInputField extends StatelessWidget {
  const BillingInputField(
      {super.key,
      required this.label,
      required this.hintText,
      this.textInputType,
      required this.controller,
      this.validator});

  final String label;
  final String hintText;
  final TextInputType? textInputType;
  final TextEditingController controller;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextFormField(
          keyboardType: textInputType,
          controller: controller,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.3)),
              border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.greyTextColor))),
        ),
      ],
    );
  }
}
