import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/components/small_button.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/session_report.dart';

class CompositionSelectorContainer extends StatefulWidget {
  const CompositionSelectorContainer({
    super.key,
    required this.session,
  });

  final Session session;

  @override
  State<CompositionSelectorContainer> createState() =>
      _CompositionSelectorContainerState();
}

class _CompositionSelectorContainerState
    extends State<CompositionSelectorContainer> {
  final WritingController writingController = Get.find<WritingController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ListModalBottomSheet(
              title: "Your Compositions",
              items: writingController.userSessions,
              onTap: (index) {
                setState(() {
                  Session session_ = writingController.userSessions[index];
                  writingController.setCurrentSession(session_);
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColors.secondaryColor,
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
                                  .copyWith(
                                      color: const Color.fromARGB(
                                          255, 96, 96, 96))),
                          const SizedBox(
                            height: defaultPadding / 2,
                          ),
                          AutoSizeText(
                            widget.session.titleOrDefault,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(),
                          )
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/icons/exchange.svg",
                      theme: const SvgTheme(currentColor: Colors.black),
                      // color: Colors.black,
                      width: 25,
                    )
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Divider(
                  color: Colors.black.withOpacity(0.1),
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
                        session: widget.session,
                      ),
                    ));
              },
              child: const SmallButton(
                text: "Scan New Composition",
                icon: Icon(
                  Icons.document_scanner,
                  color: Colors.black,
                  size: 15,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}