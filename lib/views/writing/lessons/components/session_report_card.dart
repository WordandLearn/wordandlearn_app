import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/components/small_button.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/writing/lessons/components/session_error_dialog.dart';

class SessionReportCard extends StatefulWidget {
  const SessionReportCard({
    super.key,
    required this.session,
  });

  final Session? session;

  @override
  State<SessionReportCard> createState() => _SessionReportCardState();
}

class _SessionReportCardState extends State<SessionReportCard> {
  final WritingController writingController = Get.find<WritingController>();
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(builder: (context, constraints) {
      return Center(
        child: Container(
          height: 150,
          width: constraints.maxWidth < 768
              ? constraints.maxWidth
              : constraints.maxWidth / 2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.containerColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 5,
                    spreadRadius: 1)
              ],
              image: DecorationImage(
                  fit: BoxFit.cover,
                  opacity: 0.2,
                  image: Image.asset(
                    'assets/images/gray_squiggles.png',
                    fit: BoxFit.fill,
                  ).image)),
          child: widget.session != null
              ? Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      right: 0,
                      top: -15,
                      child: Image.asset(
                        "assets/stickers/analyst_summary.png",
                        width: 120,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding * 2,
                          vertical: defaultPadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width / 2,
                            child: Text(
                              "Your composition summary is ready",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding),
                            child: SmallButton(
                              onPressed: () {
                                if (widget.session != null &&
                                    widget.session!.reportUrl != null) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  launchUrl(
                                          Uri.parse(widget.session!.reportUrl!))
                                      .onError(
                                    (error, stackTrace) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const SessionErrorDialog(
                                            title: "Could not open report",
                                            reason:
                                                "An error occurred while opening the report. Please try again later.",
                                          );
                                        },
                                      );
                                      if (error != null) {
                                        throw error;
                                      } else {
                                        throw Exception(
                                            "An error occurred while opening the report. Please try again later.");
                                      }
                                    },
                                  ).whenComplete(
                                    () {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                  );
                                } else {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  writingController
                                      .generateSessionReport(widget.session!)
                                      .then(
                                    (value) async {
                                      await launchUrl(Uri.parse(value));
                                    },
                                  ).onError(
                                    (error, stackTrace) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const SessionErrorDialog(
                                              title:
                                                  "Could not generate report",
                                              reason:
                                                  "An error occurred while generating the report. Please try again later.",
                                            );
                                          });
                                    },
                                  ).whenComplete(
                                    () {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                  );
                                }
                              },
                              text: "View Report",
                              icon: isLoading
                                  ? const LoadingSpinner(
                                      size: 17,
                                    )
                                  : const Icon(
                                      Icons.play_circle,
                                      color: Colors.black,
                                      size: 15,
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: SizedBox(
                    width: size.width,
                    height: 150,
                  )),
        ),
      );
    });
  }
}
