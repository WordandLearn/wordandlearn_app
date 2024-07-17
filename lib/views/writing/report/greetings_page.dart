import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:word_and_learn/constants/constants.dart';

class GreetingsPage extends StatefulWidget {
  const GreetingsPage({super.key});

  @override
  State<GreetingsPage> createState() => _GreetingsPageState();
}

class _GreetingsPageState extends State<GreetingsPage> {
  final Gemini gemini = Gemini.instance;
  late Future<String> introductionTextFuture;
  @override
  void initState() {
    introductionTextFuture = gemini
        .text(
            "Rephrase this, its for a child's learning application we help improve the compositions. 'Hello Edwin, Thank you for using WordandLearn, here is a summary of a composition you had written. We have provided a few lessons to help you improve. Make sure to have fun'")
        .then((value) => value!.content!.parts!.map((e) => e.text).join(""));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: defaultPadding * 2,
            ),
            child: Image.asset(
              "assets/logo/Logotype_1.png",
              width: 180,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: FutureBuilder<String>(
                future: introductionTextFuture,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Text(
                          snapshot.data!,
                          style: Theme.of(context).textTheme.titleLarge,
                        )
                      : const SizedBox.shrink();
                }),
          )
        ],
      )),
    );
  }
}
