import 'package:flutter/material.dart';

AlertDialog buildAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  String? buttonText,
  void Function()? onPressed,
  Widget? button,
}) {
  return AlertDialog(
    backgroundColor: Colors.white,
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
      textAlign: TextAlign.center,
    ),
    content: Text(content),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              )),
          TextButton(
              onPressed: onPressed,
              child: button ??
                  Text(
                    buttonText!,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w600),
                  ))
        ],
      ),
    ],
  );
}
