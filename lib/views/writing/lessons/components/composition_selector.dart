import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/session_report.dart';

class CompositionSelectorContainer extends StatelessWidget {
  const CompositionSelectorContainer({
    super.key,
    required this.session,
  });

  final Session session;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
              color: AppColors.blackContainerColor,
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(
              vertical: defaultPadding, horizontal: defaultPadding * 2),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Your current composition",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: AppColors.inactiveColor)),
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),
                        AutoSizeText(
                          session.titleOrDefault,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/icons/exchange.svg",
                    color: Colors.white,
                    width: 25,
                  )
                ],
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Divider(
                color: Colors.white.withOpacity(0.1),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: -17,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionReportPage(
                      session: session,
                    ),
                  ));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 1.5),
              decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10)),
              // alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CupertinoIcons.play_circle,
                    color: Colors.white,
                    size: 15,
                  ),
                  const SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Text(
                    "View Report",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
