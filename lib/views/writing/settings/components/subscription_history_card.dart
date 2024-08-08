import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';

class SubscriptionHistoryShimmerCard extends StatelessWidget {
  const SubscriptionHistoryShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: defaultPadding),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          width: double.infinity,
          height: 70,
        ));
  }
}

class SubscriptionHistoryCard extends StatelessWidget {
  const SubscriptionHistoryCard({
    super.key,
    required this.label,
    required this.paymentHistory,
  });
  final String label;
  final PaymentHistory paymentHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: defaultPadding),
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding * 1.5, vertical: defaultPadding * 1.5),
      child: Row(
        children: [
          Container(
              width: 40,
              height: 40,
              // padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(label))),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paymentHistory.subscription.name,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.greyTextColor,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  Text(
                    paymentHistory.paidAtFormatted,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.greyTextColor),
                  ),
                ],
              ),
            ),
          ),
          Text(
            "KES ${paymentHistory.subscription.price}",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
