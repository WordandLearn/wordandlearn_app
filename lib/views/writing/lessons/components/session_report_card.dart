import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:word_and_learn/components/small_button.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/writing/models.dart';

class SessionReportCard extends StatelessWidget {
  const SessionReportCard({
    super.key,
    required this.session,
  });

  final Session? session;
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
          child: session != null
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
                              onPressed: () async {
                                if (session != null &&
                                    session!.reportUrl != null) {
                                  await launchUrl(
                                      Uri.parse(session!.reportUrl!));
                                }
                              },
                              text: "View Report",
                              icon: const Icon(
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
