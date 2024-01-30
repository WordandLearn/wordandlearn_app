import 'package:flutter/material.dart';

class LogoType extends StatelessWidget {
  final double? width;
  final double? height;
  const LogoType({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/logo/Logotype.png",
      width: width,
      height: height,
    );
  }
}
