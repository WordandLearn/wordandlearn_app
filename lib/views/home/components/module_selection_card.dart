import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class ModuleSelectionCard extends StatelessWidget {
  const ModuleSelectionCard({
    super.key,
    required this.module,
    required this.assetUrl,
    this.onPressed,
  });
  final String module;
  final String assetUrl;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 300,
        height: 150,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
                child: Text(
                  module.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                bottom: -defaultPadding * 3,
                child: Image.asset(
                  assetUrl,
                  width: 150,
                ))
          ],
        ),
      ),
    );
  }
}
