import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class SubscriptionHistoryCard extends StatelessWidget {
  const SubscriptionHistoryCard({
    super.key,
    required this.label,
  });
  final String label;

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
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Writing Package (Personal)",
                    style:
                        TextStyle(fontSize: 14, color: AppColors.greyTextColor),
                  ),
                  SizedBox(
                    height: defaultPadding / 2,
                  ),
                  Text(
                    "8th March 2024",
                    style:
                        TextStyle(fontSize: 12, color: AppColors.greyTextColor),
                  ),
                ],
              ),
            ),
          ),
          const Text(
            "\$12.00",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
