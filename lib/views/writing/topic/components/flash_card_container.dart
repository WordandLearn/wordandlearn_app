// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
// import 'package:word_and_learn/constants/constants.dart';
// import 'package:word_and_learn/models/flash_card_text.dart';
// import 'package:word_and_learn/models/models.dart';

// class FlashCardContainer extends StatefulWidget {
//   const FlashCardContainer(
//       {super.key,
//       required this.flashcards,
//       this.onCompleted,
//       this.onChanged,
//       this.lesson});

//   final List<FlashcardText> flashcards;
//   final Function? onCompleted;
//   final Lesson? lesson;
//   final void Function(int index)? onChanged;

//   @override
//   State<FlashCardContainer> createState() => _FlashCardContainerState();
// }

// class _FlashCardContainerState extends State<FlashCardContainer> {
//   int activeIndex = 0;

//   void goToNext() {
//     if (activeIndex < widget.flashcards.length - 1) {
//       if (activeIndex == widget.flashcards.length - 2) {
//         if (widget.onCompleted != null) {
//           widget.onCompleted!();
//         }
//       }
//       setState(() {
//         activeIndex++;
//         if (widget.onChanged != null) {
//           widget.onChanged!(activeIndex);
//         }
//       });
//     }
//   }

//   void goToPrevious() {
//     if (activeIndex > 0) {
//       setState(() {
//         activeIndex--;
//         if (widget.onChanged != null) {
//           widget.onChanged!(activeIndex);
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     FlashcardText activeFlashcard = widget.flashcards[activeIndex];
//     // Size size = MediaQuery.of(context).size;
//     return SwipeDetector(
//         onSwipeRight: (offset) => goToPrevious(),
//         onSwipeLeft: (offset) => goToNext(),
//         child: Container(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: defaultPadding * 1.5, vertical: defaultPadding),
//             decoration: BoxDecoration(color: AppColors.secondaryColor),
//             child: Column(
//               children: [
//                 Text("Read Carefully"),
//                 Expanded(
//                   child: AutoSizeText(
//                     activeFlashcard.text,
//                     style: TextStyle(fontSize: 24, height: 2),
//                   ),
//                 ),
//               ],
//             )));
//   }
// }
