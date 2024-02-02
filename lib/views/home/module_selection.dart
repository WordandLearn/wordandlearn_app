import 'package:flutter/material.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/views/writing/home.dart';

import 'components/module_selection_card.dart';

class ModuleSelection extends StatelessWidget {
  const ModuleSelection({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScaffold(
        body: SizedBox(
      height: size.height * 0.95,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.05,
            child: const LogoType(
              width: 100,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
            child: SizedBox(
              width: size.width * 0.8,
              child: const MascotText(
                  height: 80,
                  text:
                      "What are we going to learn today? Choose one of the sections below to start learning!"),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ModuleSelectionCard(
                    onPressed: () {},
                    module: "Reading",
                    assetUrl: "assets/images/girl_reading.png",
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  ModuleSelectionCard(
                    module: "Writing",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WritingHome(),
                          ));
                    },
                    assetUrl: "assets/images/boy_writing.png",
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
