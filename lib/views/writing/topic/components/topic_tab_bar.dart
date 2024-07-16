import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class TopicTabBar extends StatelessWidget {
  const TopicTabBar({
    super.key,
    required this.onChanged,
    required this.activeIndex,
  });

  final void Function(int index) onChanged;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  onChanged(0);
                },
                child: _TopicTab(
                  text: "Lessons",
                  active: activeIndex == 0,
                ),
              ),
            ),
            Expanded(
                child: InkWell(
                    onTap: () {
                      onChanged(1);
                    },
                    child: _TopicTab(
                        text: "Description", active: activeIndex == 1))),
          ],
        )
      ],
    );
  }
}

class _TopicTab extends StatelessWidget {
  const _TopicTab({
    required this.text,
    required this.active,
  });
  final String text;
  final bool active;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      height: 50,
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      decoration: BoxDecoration(
          color: active ? AppColors.blackContainerColor : Colors.transparent,
          borderRadius: BorderRadius.circular(30)),
      child: Center(
          child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : Colors.black),
      )),
    );
  }
}
