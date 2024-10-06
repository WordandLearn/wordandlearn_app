import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/views/writing/lessons/components/session_error_dialog.dart';
import 'package:word_and_learn/views/writing/upload/onboarding.dart';

class LessonEmptyState extends StatefulWidget {
  const LessonEmptyState({
    super.key,
  });

  @override
  State<LessonEmptyState> createState() => _LessonEmptyStateState();
}

class _LessonEmptyStateState extends State<LessonEmptyState> {
  final WritingController writingController = Get.find<WritingController>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/illustrations/kids-reading.png",
          height: size.height * 0.25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: defaultPadding),
                child: Text(
                  "No compositions Yet?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/lightning.svg",
                      width: 30,
                      // ignore: deprecated_member_use
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    const Expanded(
                      child: Text(
                        "Scan your first composition to get your assessment report and insights",
                        style: TextStyle(height: 2),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/lightning.svg",
                    width: 30,
                    // ignore: deprecated_member_use
                    color: AppColors.secondaryColor,
                  ),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  const Expanded(
                    child: Text(
                      "Access detailed lessons and exercises to improve your writing",
                      style: TextStyle(height: 2),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        TapBounce(
          onTap: () {
            setState(() {
              loading = true;
            });
            writingController.checkUploadComposition().then((value) {
              if (value.canUpload) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const UploadOnboardingPage();
                }));
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SessionErrorDialog(
                      title: "Cannot Upload A Composition",
                      reason: value.reason ??
                          "There is an error on our end, you can try again later",
                    );
                  },
                );
              }
            }).onError(
              (error, stackTrace) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text("An error occurred. Please try again later")));
              },
            ).whenComplete(
              () => setState(() {
                loading = false;
              }),
            );
          },
          child: PrimaryIconButton(
              text: "Upload New Composition",
              icon: loading
                  ? const LoadingSpinner(
                      size: 17,
                    )
                  : const Icon(
                      FeatherIcons.camera,
                      size: 17,
                      color: Colors.white,
                    )),
        ),
      ],
    );
  }
}
