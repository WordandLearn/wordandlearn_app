import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/views/writing/upload/composition_upload_page.dart';

class UploadOnboardingPage extends StatefulWidget {
  const UploadOnboardingPage({super.key});

  @override
  State<UploadOnboardingPage> createState() => _UploadOnboardingPageState();
}

class _UploadOnboardingPageState extends State<UploadOnboardingPage> {
  int activePage = 0;
  final PageController _pageController = PageController();

  void _goToPreviousPage() {
    if (activePage > 0) {
      _pageController.animateToPage(activePage - 1,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      setState(() {
        activePage--;
      });
    }
  }

  void _goToNextPage() {
    if (activePage < 3) {
      _pageController.animateToPage(activePage + 1,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      setState(() {
        activePage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _UploadOnboardingPageItem(
                  illustrationUrl: "assets/illustrations/cloud_upload.png",
                  title: "Uploading a Composition",
                  onSwipeRight: _goToPreviousPage,
                  onSwipeLeft: _goToNextPage,
                  description:
                      "Let us show you how you can upload your composition and start learning. Exciting!",
                  activePage: activePage,
                ),
                _UploadOnboardingPageItem(
                  illustrationUrl: "assets/illustrations/photo_upload.png",
                  title: "Take a Photo of Your Composition",
                  description:
                      "Take a clear photo of your composition. Make sure it's easy to read so we can enjoy your writing.",
                  activePage: activePage,
                  onSwipeRight: _goToPreviousPage,
                  onSwipeLeft: _goToNextPage,
                ),
                _UploadOnboardingPageItem(
                  illustrationUrl: "assets/illustrations/confirm.png",
                  title: "Confirm & Upload",
                  description:
                      "Check your photo to ensure every page is clear. Once you're ready, hit the upload button to send us your composition.",
                  activePage: activePage,
                  onSwipeRight: _goToPreviousPage,
                  onSwipeLeft: _goToNextPage,
                ),
                _UploadOnboardingPageItem(
                  illustrationUrl: "assets/illustrations/chill.png",
                  title: "Sit Back & Relax",
                  description:
                      "You're all set! Now you can sit back and relax for about 2 minutes while we review your work. Thanks for sharing your writing with us.",
                  activePage: activePage,
                  onSwipeRight: _goToPreviousPage,
                  onSwipeLeft: _goToNextPage,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding * 2, horizontal: defaultPadding * 2),
            child: Row(
              children: [
                TapBounce(
                  onTap: () {
                    if (activePage > 0) {
                      _pageController.animateToPage(activePage - 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                      setState(() {
                        activePage--;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.chevron_left_rounded),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      Text(
                        "Back",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TapBounce(
                  onTap: () async {
                    if (activePage < 3) {
                      _pageController.animateToPage(activePage + 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                      setState(() {
                        activePage++;
                      });
                    } else {
                      List<String?>? pictures =
                          await CunningDocumentScanner.getPictures(
                              isGalleryImportAllowed: true, noOfPages: 2);
                      if (pictures != null) {
                        if (context.mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CompositionUploadPage(
                                        imagePaths: pictures,
                                      ),
                                  settings: const RouteSettings(
                                      name: "CompositionUploadPage")));
                        }
                      }
                    }
                  },
                  child: PrimaryButton(
                      color: AppColors.buttonColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Row(
                          children: [
                            Text(
                              activePage == 3 ? "Proceed to Upload" : "Next",
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              width: defaultPadding,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              // padding: const EdgeInsets.all(defaultPadding / 2),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Icon(
                                CupertinoIcons.forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _UploadOnboardingPageItem extends StatefulWidget {
  const _UploadOnboardingPageItem({
    required this.illustrationUrl,
    required this.title,
    required this.description,
    required this.activePage,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });
  final String illustrationUrl;
  final String title;
  final String description;
  final int activePage;
  final void Function() onSwipeLeft;
  final void Function() onSwipeRight;

  @override
  State<_UploadOnboardingPageItem> createState() =>
      _UploadOnboardingPageItemState();
}

class _UploadOnboardingPageItemState extends State<_UploadOnboardingPageItem> {
  double rotation = 0.0;

  void _animateSwipe(bool directionRight) {
    setState(() {
      rotation = directionRight ? 0.05 : -0.05;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        rotation = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SwipeDetector(
          onSwipeLeft: (offset) {
            _animateSwipe(false);
            Future.delayed(const Duration(milliseconds: 100), () {
              widget.onSwipeLeft();
            });
          },
          onSwipeRight: (offset) {
            _animateSwipe(true);
            Future.delayed(const Duration(milliseconds: 300), () {
              widget.onSwipeRight();
            });
          },
          child: Container(
              height: size.height * 0.6,
              padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                gradient: LinearGradient(colors: [
                  AppColors.secondaryColor,
                  AppColors.primaryColor.withOpacity(0.5)
                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) {
                            return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                width: 20,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: index == widget.activePage
                                        ? AppColors.buttonColor
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(5)));
                          },
                        )),
                    const Spacer(),
                    AnimatedRotation(
                        turns: rotation,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 500),
                        child: Image.asset(widget.illustrationUrl)),
                  ],
                ),
              )),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 22),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.7,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
