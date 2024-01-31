import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomImage;
  final Widget? appBar;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  const CustomScaffold(
      {super.key,
      required this.body,
      this.bottomImage,
      this.appBar,
      this.bottomNavigationBar,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: scrollPadding,
              child: Column(
                children: [
                  if (appBar != null) appBar!,
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding * 2),
                    child: body,
                  )),
                ],
              ),
            ),
            if (bottomImage != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: bottomImage,
              ),
          ],
        ),
      ),
    );
  }
}
