import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/flash_card_text.dart';

class FlashCardContainer extends StatefulWidget {
  const FlashCardContainer({
    super.key,
    required this.flashcards,
    required this.onCompleted,
  });

  final List<FlashcardText> flashcards;
  final Function onCompleted;

  @override
  State<FlashCardContainer> createState() => _FlashCardContainerState();
}

class _FlashCardContainerState extends State<FlashCardContainer> {
  int activeIndex = 0;

  void goToNext() {
    if (activeIndex < widget.flashcards.length - 1) {
      if (activeIndex == widget.flashcards.length - 2) {
        widget.onCompleted();
      }
      setState(() {
        activeIndex++;
      });
    }
  }

  void goToPrevious() {
    if (activeIndex > 0) {
      setState(() {
        activeIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FlashcardText activeFlashcard = widget.flashcards[activeIndex];
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width,
          height: size.height * 0.6,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                padding: allPadding * 2,
                child: Center(
                  child: Text(
                    activeFlashcard.text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(height: 2, fontSize: 30),
                  ),
                ),
              )),
              Padding(
                padding: allPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      widget.flashcards.length,
                      (index) => Expanded(
                            flex: activeIndex == index ? 2 : 1,
                            child: AnimatedContainer(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2),
                              duration: const Duration(milliseconds: 300),
                              height: 10,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: activeIndex == index
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          )),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: allPadding * 1.5),
                  onPressed: () {
                    goToPrevious();
                  },
                  child: const Icon(Icons.chevron_left_rounded)),
              const SizedBox(
                width: defaultPadding * 5,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: allPadding * 1.5),
                  onPressed: () {
                    goToNext();
                  },
                  child: const Icon(Icons.chevron_right_rounded))
            ],
          ),
        )
      ],
    );
  }
}
