import 'package:flutter/material.dart';

AppBar buildSettingsAppBar(BuildContext context, {required String title}) {
  return AppBar(
    backgroundColor: Colors.white,
    title: Text(
      title,
      style: const TextStyle(fontSize: 16),
    ),
    centerTitle: true,
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.chevron_left,
          size: 30,
        )),
  );
}
