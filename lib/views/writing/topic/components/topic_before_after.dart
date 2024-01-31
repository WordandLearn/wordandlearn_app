import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/example.dart';
import 'package:word_and_learn/utils/timer.dart';

Color beforeColor = const Color(0xFF82E7FE);

Color afterColor = const Color(0xFFFFE482);

class TopicBeforeAfter extends StatefulWidget {
  const TopicBeforeAfter({
    super.key,
    required this.example,
    this.isBefore = true,
    this.onBefore,
    this.onNext,
    this.onAfter,
    this.onPrevious,
  });
  final Example example;
  final bool isBefore;
  final void Function()? onBefore;
  final void Function()? onNext;
  final void Function()? onPrevious;
  final void Function()? onAfter;

  @override
  State<TopicBeforeAfter> createState() => _TopicBeforeAfterState();
}

class _TopicBeforeAfterState extends State<TopicBeforeAfter> {
  bool isBefore = true;
  @override
  void initState() {
    setState(() {
      isBefore = widget.isBefore;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          children: [
            SvgPicture.asset(
              isBefore ? "assets/icons/sad.svg" : "assets/icons/happy.svg",
              width: 70,
              height: 70,
            ),
            Text(
              isBefore ? "Before" : "After",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
          child: Column(
            children: [
              Text(
                isBefore ? widget.example.beforeText : widget.example.afterText,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              // if (!isBefore)
              //   Padding(
              //     padding: EdgeInsets.symmetric(vertical: size.height * 0.1),
              //     child: const MascotText(
              //         height: 100,
              //         text:
              //             "We changed happy to joyful! to make it more interesting"),
              //   ),
            ],
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                if (isBefore) {
                  widget.onPrevious!();
                } else {
                  setState(() {
                    isBefore = !isBefore;
                  });
                  widget.onBefore!();
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_left_rounded,
                    size: 50,
                  ),
                  Text(
                    isBefore ? "Previous" : "Before",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              height: 35,
              child: isBefore
                  ? TimedWidget(
                      duration: TimerUtil.timeToRead(widget.example.beforeText),
                      child: CustomPrimaryButton(
                        text: "After",
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          setState(() {
                            isBefore = isBefore;

                            widget.onAfter!();
                          });
                        },
                      ),
                    )
                  : TimedWidget(
                      duration: TimerUtil.timeToRead(widget.example.afterText),
                      child: CustomPrimaryButton(
                        text: "Next",
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            isBefore = !isBefore;
                          });

                          widget.onNext!();
                        },
                      ),
                    ),
            ),
          ],
        )
      ],
    );
  }
}
