import 'package:flutter/material.dart';

class Mascot extends StatelessWidget {
  const Mascot({super.key, this.size = 100});
  final double size;
  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/mascot_primary.png",
        width: size, height: size);
  }
}
