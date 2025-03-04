import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/utils/sticker_utils.dart';

class SessionSuccessDialog extends StatelessWidget {
  const SessionSuccessDialog(
      {super.key, this.action, required this.title, required this.reason});
  final Widget? action;
  final String title;
  final String reason;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: SizedBox(
        height: 250,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding * 2, vertical: defaultPadding * 2),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding / 2),
                    child: Text(
                      reason,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textColor),
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding * 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.chevron_left),
                            Text(
                              "Go Back",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      action != null ? action! : const SizedBox.shrink()
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              top: -70,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  StickerUtils.getRandomSuccessSticker(),
                  width: 180,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
