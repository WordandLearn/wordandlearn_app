import 'package:flutter/material.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';

class PaymentSettings extends StatelessWidget {
  const PaymentSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildSettingsAppBar(context, title: "Payment & Subscription"),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: const Column(
                children: [
                  Text(
                    "Manage Your WordandLearn Subscription",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
