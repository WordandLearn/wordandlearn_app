import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/views/writing/settings/components/plan_list_modal.dart';

class SubscriptionInactiveWidget extends StatelessWidget {
  const SubscriptionInactiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.9,
      child: ListView(
        padding: allPadding,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LogoType(
                width: 80,
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Start Subscription"),
              Text(
                  "To use Re-Write and enjoy a redefined writing experience, you need to subscribe to a plan."),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Choose a Plan"),
              Container(
                child: Column(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
