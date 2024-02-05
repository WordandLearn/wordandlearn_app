import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  const IconContainer(
      {super.key,
      required this.child,
      this.color,
      this.size = const Size(20, 20)});
  final Widget child;
  final Color? color;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      // padding: allPadding * 1.5,
      decoration: BoxDecoration(
          color: color ?? Theme.of(context).primaryColor,
          shape: BoxShape.circle),
      child: child,
    );
  }
}
