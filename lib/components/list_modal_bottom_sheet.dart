import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class ListModalBottomSheet<T> extends StatelessWidget {
  const ListModalBottomSheet(
      {super.key,
      required this.title,
      required this.items,
      required this.onTap});
  final String title;
  final List<T> items;
  final void Function(int index) onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: allPadding * 2,
      decoration: BoxDecoration(
          color: AppColors.blackContainerColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.white.withOpacity(0.4),
                );
              },
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: InkWell(
                    onTap: () {
                      onTap(index);
                    },
                    child: Row(
                      children: [
                        Text((index + 1).toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.white)),
                        const SizedBox(
                          width: defaultPadding * 2,
                        ),
                        Text(
                          items[index].toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}