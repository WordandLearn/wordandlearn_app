import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.onPressed});
  final void Function()? onPressed;

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
        child: const Icon(Icons.arrow_back_ios));
  }
}
