import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/flash_card_text.dart';

class FlashCardContainer extends StatefulWidget {
  const FlashCardContainer(
      {super.key, required this.flashcards, this.onCompleted, this.onChanged});

  final List<FlashcardText> flashcards;
  final Function? onCompleted;
  final void Function(int index)? onChanged;

  @override
  State<FlashCardContainer> createState() => _FlashCardContainerState();
}

class _FlashCardContainerState extends State<FlashCardContainer> {
  int activeIndex = 0;

  void goToNext() {
    if (activeIndex < widget.flashcards.length - 1) {
      if (activeIndex == widget.flashcards.length - 2) {
        if (widget.onCompleted != null) {
          widget.onCompleted!();
        }
      }
      setState(() {
        activeIndex++;
        if (widget.onChanged != null) {
          widget.onChanged!(activeIndex);
        }
      });
    }
  }

  void goToPrevious() {
    if (activeIndex > 0) {
      setState(() {
        activeIndex--;
        if (widget.onChanged != null) {
          widget.onChanged!(activeIndex);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FlashcardText activeFlashcard = widget.flashcards[activeIndex];
    Size size = MediaQuery.of(context).size;
    return SwipeDetector(
      onSwipeRight: (offset) => goToPrevious(),
      onSwipeLeft: (offset) => goToNext(),
      child: AnimatedContainer(
        width: size.width,
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding),
        decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(30)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: defaultPadding * 2, top: defaultPadding),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/fire.svg",
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Text(
                    "Read carefully",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: allPadding * 2,
                  child: Center(
                    child: FadeTransition(
                      opacity: const AlwaysStoppedAnimation(1),
                      child: AutoSizeText(
                        activeFlashcard.text,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(height: 2, fontSize: 30),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
