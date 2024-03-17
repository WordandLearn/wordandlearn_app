import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.onPressed, this.color});
  final void Function()? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          } else {
            Navigator.pop(context);
          }
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: color,
        ));
  }
}
