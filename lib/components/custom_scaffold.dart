import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomImage;
  const CustomScaffold({super.key, required this.body, this.bottomImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: scrollPadding,
              child: body,
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
