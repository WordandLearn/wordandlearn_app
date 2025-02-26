import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/spacings.dart';

class SamplesPage extends StatelessWidget {
  const SamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context)),
          title: const Text(
            'Try using our samples',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: const SafeArea(
          child: Padding(
            padding: scrollPadding,
            child: Column(
              children: [
                Text(
                    "These are samples on a composition that will be used as reference")
              ],
            ),
          ),
        ));
  }
}
