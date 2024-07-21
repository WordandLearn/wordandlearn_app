import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/colors.dart';
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
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _UploadOnboardingPageItem(
                    illustrationUrl: "assets/illustrations/cloud_upload.png",
                    title: "Uploading a Composition",
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
                  ),
                  _UploadOnboardingPageItem(
                    illustrationUrl: "assets/illustrations/confirm.png",
                    title: "Confirm & Upload",
                    description:
                        "Check your photo to ensure every page is clear. Once you're ready, hit the upload button to send us your composition.",
                    activePage: activePage,
                  ),
                  _UploadOnboardingPageItem(
                    illustrationUrl: "assets/illustrations/chill.png",
                    title: "Sit Back & Relax",
                    description:
                        "You're all set! Now you can sit back and relax for about 2 minutes while we review your work. Thanks for sharing your writing with us.",
                    activePage: activePage,
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
                    onTap: () {
                      if (activePage < 3) {
                        _pageController.animateToPage(activePage + 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                        setState(() {
                          activePage++;
                        });
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CompositionUploadPage(),
                                settings: const RouteSettings(
                                    name: "CompositionUploadPage")));
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
      ),
    );
  }
}

class _UploadOnboardingPageItem extends StatelessWidget {
  const _UploadOnboardingPageItem({
    super.key,
    required this.illustrationUrl,
    required this.title,
    required this.description,
    required this.activePage,
  });
  final String illustrationUrl;
  final String title;
  final String description;
  final int activePage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: defaultPadding, horizontal: defaultPadding * 2),
          child: Container(
              height: size.height * 0.6,
              padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
              decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  gradient: LinearGradient(colors: [
                    AppColors.secondaryColor,
                    AppColors.primaryColor.withOpacity(0.5)
                  ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) {
                          return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: 20,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: index == activePage
                                      ? AppColors.buttonColor
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(5)));
                        },
                      )),
                  const Spacer(),
                  Image.asset(illustrationUrl),
                ],
              )),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            child: Expanded(
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 22),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Text(
                      description,
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
        ),
      ],
    );
  }
}
