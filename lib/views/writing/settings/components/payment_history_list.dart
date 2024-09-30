import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';

import 'subscription_history_card.dart';

class PaymentHistoryList extends StatefulWidget {
  const PaymentHistoryList({
    super.key,
  });

  @override
  State<PaymentHistoryList> createState() => _PaymentHistoryListState();
}

class _PaymentHistoryListState extends State<PaymentHistoryList> {
  late Future<List<PaymentHistory>?> _future;

  final WritingController _writingController = Get.find<WritingController>();

  @override
  void initState() {
    _future = _writingController.getPaymentHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              "Payment History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        FutureBuilder<List<PaymentHistory>?>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, index) =>
                      const SubscriptionHistoryShimmerCard(),
                );
              }
              return snapshot.hasData
                  ? ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return SubscriptionHistoryCard(
                          label: (index + 1).toString(),
                          paymentHistory: snapshot.data![index],
                        );
                      })
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: defaultPadding),
                      child: Center(child: Text("No Payments Have been made")),
                    );
            })
      ],
    );
  }
}
