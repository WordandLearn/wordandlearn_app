import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/flash_card_text.dart';
import 'package:word_and_learn/utils/timer.dart';

class TopicNoteCard extends StatefulWidget {
  const TopicNoteCard(
      {super.key,
      required this.flashcardText,
      this.isOpened = false,
      required this.onClicked});
  final FlashcardText flashcardText;
  final bool isOpened;
  final void Function() onClicked;
  @override
  State<TopicNoteCard> createState() => _TopicNoteCardState();
}

class _TopicNoteCardState extends State<TopicNoteCard> {
  late Future<String?> _titleFuture;
  @override
  void initState() {
    _titleFuture = widget.flashcardText.flashCardTitle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClicked,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(vertical: defaultPadding),
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding * 2, vertical: defaultPadding),
          decoration: BoxDecoration(
              color: widget.flashcardText.colorValue,
              border: widget.flashcardText.completed != null &&
                      widget.flashcardText.completed!
                  ? Border.all(color: AppColors.greenColor, width: 1)
                  : null,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FractionallySizedBox(
                widthFactor: 0.8,
                child: FutureBuilder<String?>(
                    future: _titleFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[200]!,
                            child: Container(
                              width: 100,
                              height: 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey),
                            ));
                      }
                      return Text(
                        snapshot.hasData && snapshot.data != null
                            ? snapshot.data!
                            : "Title Loading...",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      );
                    }),
              ),
              widget.isOpened
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding / 2),
                      child: Text(
                        widget.flashcardText.text,
                        maxLines: 3,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, height: 1.5),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : const SizedBox.shrink(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                child: Row(
                  children: [
                    widget.isOpened
                        ? const Text(
                            "* Click To Take Lesson",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          )
                        : const SizedBox.shrink(),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          CupertinoIcons.clock,
                          size: 15,
                          color: Colors.grey,
                        ),
                        Text(
                          TimerUtil.timeFormat(
                              TimerUtil.timeToRead(widget.flashcardText.text) *
                                  3),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
