import 'package:auto_size_text/auto_size_text.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/components/small_button.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/payments/payment_models.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/utils/exceptions.dart';
import 'package:word_and_learn/views/writing/lessons/components/session_error_dialog.dart';
import 'package:word_and_learn/views/writing/settings/subscription_settings.dart';
import 'package:word_and_learn/views/writing/upload/composition_upload_page.dart';
import 'package:word_and_learn/views/writing/upload/onboarding.dart';

class CompositionSelectorContainer extends StatefulWidget {
  const CompositionSelectorContainer({
    super.key,
    required this.session,
    required this.userSessions,
    required this.onChanged,
  });

  final Session session;

  final List<Session> userSessions;
  final void Function(Session session) onChanged;

  @override
  State<CompositionSelectorContainer> createState() =>
      _CompositionSelectorContainerState();
}

class _CompositionSelectorContainerState
    extends State<CompositionSelectorContainer> {
  final WritingController writingController = Get.find<WritingController>();

  bool loading = false;

  Future<void> goToUpload(BuildContext context) async {
    // if (kIsWeb) {
    //   if (context.mounted) {
    //     showDialog(
    //       context: context,
    //       builder: (context) {
    //         return const SessionErrorDialog(
    //           title: "Error",
    //           reason: "Scanning a composition is only available on mobile.",
    //         );
    //       },
    //     );
    //   }
    // }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey("uploadOnboarded")) {
      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                maintainState: false,
                builder: (context) => const UploadOnboardingPage(),
                settings: const RouteSettings(name: "UploadOnboardingPage")));
      }
    } else {
      if (context.mounted) {
        List<String?>? pictures = await CunningDocumentScanner.getPictures(
            noOfPages: 2, isGalleryImportAllowed: true);
        if (pictures != null) {
          if (context.mounted) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    maintainState: false,
                    builder: (context) => CompositionUploadPage(
                          imagePaths: pictures,
                        )));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ListModalBottomSheet(
              title: "Your Compositions",
              items: widget.userSessions,
              onTap: (index) {
                Session session_ = widget.userSessions[index];
                widget.onChanged(session_);
                Navigator.pop(context);
              },
            );
          },
        );
      },
      child: SizedBox(
        height: 130,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 120,
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
                                  .copyWith(fontSize: 18),
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
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 12,
                          ),
                          SizedBox(
                            width: defaultPadding / 2,
                          ),
                          Text(
                            "Click To Switch Compositions",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.greyTextColor),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: SmallButton(
                isLoading: loading,
                onPressed: () async {
                  //Check if the current session is complete

                  if (writingController.subscriptionStatus !=
                      SubscriptionStatus.trialActive) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SessionErrorDialog(
                          title: "You cannot upload a new composition",
                          reason: "Complete your subscription to continue",
                          action: TapBounce(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return const SubscriptionSettings();
                                  },
                                ));
                              },
                              child: const PrimaryIconButton(
                                  text: "Subscribe",
                                  icon: Icon(
                                    CupertinoIcons.chevron_right,
                                    color: Colors.white,
                                    size: 17,
                                  ))),
                        );
                      },
                    );
                    return;
                  } else {
                    setState(() {
                      loading = true;
                    });

                    if (writingController.currentUserSession.value != null) {
                      writingController.checkUploadComposition().then(
                        (value) async {
                          if (value.canUpload) {
                            await goToUpload(context);
                          } else {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return SessionErrorDialog(
                                    title:
                                        "You cannot upload a new composition",
                                    reason: value.reason ??
                                        "There is an error on our end, you can try again later",
                                  );
                                },
                              );
                              return;
                            }
                          }
                        },
                      ).onError(
                        (error, stackTrace) {
                          if (error is HttpFetchException) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SessionErrorDialog(
                                  title: error.statusCode < 500
                                      ? "You cannot upload a composition"
                                      : "Could not check if session is complete",
                                  reason: error.statusCode < 500
                                      ? "Ensure you have completed the current session, or you havent reached your plan upload limit."
                                      : "An error occurred while checking if the session is complete. Don't worry its an issue on our end, you can try again later",
                                );
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Could not check if session is complete")));
                          }
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
                text: "Scan New Composition",
                icon: const Icon(
                  Icons.document_scanner,
                  color: Colors.black,
                  size: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
