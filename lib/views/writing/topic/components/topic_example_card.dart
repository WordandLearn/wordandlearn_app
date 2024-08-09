import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/writing/topic/components/example_dialog.dart';

class TopicExampleCard extends StatefulWidget {
  const TopicExampleCard(
      {super.key,
      required this.example,
      this.visited = false,
      required this.onUnderstand,
      required this.index});
  final Example example;
  final bool visited;
  final int index;
  final void Function(int index) onUnderstand;

  @override
  State<TopicExampleCard> createState() => _TopicExampleCardState();
}

class _TopicExampleCardState extends State<TopicExampleCard> {
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: widget.example.completed,
      builder: (context) {
        return ExampleDialog(
          example: widget.example,
          onUnderstand: () {
            widget.onUnderstand(widget.index);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width,
        child: Column(
          key: ValueKey<String>(widget.example.originalText),
          children: [
            Expanded(
              flex: 1,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.all(defaultPadding * 2),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  child: AutoSizeText(widget.example.originalText,
                      // textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 18, height: 2)),
                ),
              ),
            ),
            Expanded(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.all(defaultPadding * 2),
                  decoration: const BoxDecoration(
                      color: AppColors.greenColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20))),
                  child: Column(
                    children: [
                      Expanded(
                        child: AutoSizeText(widget.example.transformedText,
                            style: const TextStyle(fontSize: 18, height: 2)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: defaultPadding),
                        child: TapBounce(
                          duration: const Duration(milliseconds: 150),
                          onTap: () {
                            _showAlertDialog(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding * 1.5,
                                  vertical: defaultPadding),
                              decoration: BoxDecoration(
                                  color: AppColors.secondaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.25),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5))
                                  ],
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Text(
                                "Reveal Instructions",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )),
                        ),
                      )
                    ],
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
