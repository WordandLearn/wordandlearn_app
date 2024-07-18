import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:word_and_learn/constants/constants.dart';

class TopicBottomNavBar extends StatefulWidget {
  const TopicBottomNavBar({
    super.key,
    required this.onChanged,
  });

  @override
  State<TopicBottomNavBar> createState() => _TopicBottomNavBarState();

  final void Function(int index) onChanged;
}

class _TopicBottomNavBarState extends State<TopicBottomNavBar> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding * 2, vertical: defaultPadding),
      height: 50,
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 0;
              });
              widget.onChanged(0);
            },
            child: _NavItem(
              text: "Notes",
              isActive: activeIndex == 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 3),
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    activeIndex = 1;
                  });
                  widget.onChanged(1);
                },
                child: _NavItem(
                  text: "Examples",
                  isActive: activeIndex == 1,
                )),
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  activeIndex = 2;
                });
                widget.onChanged(2);
              },
              child: _NavItem(
                text: "Exercise",
                isActive: activeIndex == 2,
              )),

          const Spacer(),
          //TODO: Adjust Percentage depending on progress
          CircularPercentIndicator(
            radius: 10,
            percent: 0.5,
            progressColor: AppColors.secondaryColor,
          )
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.text,
    this.isActive = false,
  });
  final String text;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isActive
              ? Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                )
              : const SizedBox.shrink(),
        )
      ],
    );
  }
}
