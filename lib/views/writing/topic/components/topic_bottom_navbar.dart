import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/writing/topic.dart';

class TopicBottomNavBar extends StatefulWidget {
  const TopicBottomNavBar({
    super.key,
    required this.onChanged,
    required this.completedStatus,
    required this.onInvalidClick,
    required this.progress,
    this.index = 0,
    required this.topic,
  });

  @override
  State<TopicBottomNavBar> createState() => _TopicBottomNavBarState();

  final void Function(int index) onChanged;
  final List<bool> completedStatus;
  final double progress;
  //invalid click is when its clicked and lesson is not complete
  final void Function(int index) onInvalidClick;
  final int index;
  final Topic topic;
}

class _TopicBottomNavBarState extends State<TopicBottomNavBar> {
  int activeIndex = 0;

  @override
  void initState() {
    setState(() {
      activeIndex = widget.index;
    });
    super.initState();
  }

  void changePage(index) {
    widget.onChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding * 2, vertical: defaultPadding),
      height: 50,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                activeIndex = 0;
              });
              changePage(0);
            },
            child: _NavItem(
              text: "Notes",
              assetImage: "assets/stickers/note_bear.png",
              isActive: activeIndex == 0,
              isComplete: widget.completedStatus[0],
              index: 1,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  height: 3,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20)),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.decelerate,
                  child: FractionallySizedBox(
                    widthFactor: widget.progress,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      height: 3,
                      decoration: BoxDecoration(
                          color: widget.topic.darkerColor,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
              onTap: () {
                if (widget.completedStatus[0] == false) {
                  widget.onInvalidClick(1);
                  return;
                }

                setState(() {
                  activeIndex = 1;
                });

                changePage(1);
              },
              child: _NavItem(
                text: "Examples",
                assetImage: "assets/stickers/example_bear.png",
                isActive: activeIndex == 1,
                index: 2,
                isComplete: widget.completedStatus[1],
              )),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.text,
    this.isComplete = false,
    this.isActive = false,
    required this.index,
    required this.assetImage,
  });
  final String text;
  final bool isActive;
  final bool isComplete;
  final int index;
  final String assetImage;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Padding(
        padding: isActive
            ? const EdgeInsets.symmetric(horizontal: defaultPadding / 4)
            : EdgeInsets.zero,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: isComplete ? AppColors.greenColor : null,
                border: isComplete
                    ? null
                    : Border.all(
                        color: isActive ? AppColors.buttonColor : Colors.grey,
                        width: 1.4),
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: isComplete
                      ? const Icon(
                          Icons.done_rounded,
                          color: Colors.white,
                          size: 15,
                        )
                      : Text(
                          "$index",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isActive
                                  ? AppColors.buttonColor
                                  : Colors.grey),
                        )),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    color: isActive ? Colors.black : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
