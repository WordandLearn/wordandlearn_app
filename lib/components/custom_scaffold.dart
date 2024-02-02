import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomImage;
  final Widget? appBar;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final Widget? drawer;
  const CustomScaffold(
      {super.key,
      required this.body,
      this.bottomImage,
      this.appBar,
      this.padding = scrollPadding,
      this.bottomNavigationBar,
      this.backgroundColor,
      this.drawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: backgroundColor,
      drawer: drawer,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: padding,
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
