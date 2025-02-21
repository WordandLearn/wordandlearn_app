import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/xfile_image_builder.dart';
import 'package:word_and_learn/constants/constants.dart';

class ExerciseSubmissionPage extends StatefulWidget {
  const ExerciseSubmissionPage({
    super.key,
    required this.files,
  });

  final List<XFile> files;

  @override
  State<ExerciseSubmissionPage> createState() => _ExerciseSubmissionPageState();
}

class _ExerciseSubmissionPageState extends State<ExerciseSubmissionPage> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Builder(builder: (context) {
      return Column(
        children: [
          Text(
            "Your Submission",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Expanded(
            child: widget.files.isNotEmpty
                ? Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                          key: ValueKey<String>(widget.files[activeIndex].path),
                          child: XFileImageBuilder(
                            xfile: widget.files[activeIndex],
                            width: 200,
                            height: 200,
                          )),
                    ),
                  )
                : const SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("No image has been submitted")),
                      ],
                    ),
                  ),
          ),
          widget.files.length > 1
              ? Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    width: size.width * 0.65,
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding, vertical: defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          widget.files.length,
                          (index) => InkWell(
                                onTap: () {
                                  setState(() {
                                    activeIndex = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding / 2),
                                  decoration: BoxDecoration(
                                      border: activeIndex == index
                                          ? Border.all(
                                              color: AppColors.buttonColor,
                                              width: 2)
                                          : null,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: XFileImageBuilder(
                                      xfile: widget.files[index],
                                      width: 50,
                                      height: 70,
                                    ),
                                  ),
                                ),
                              )),
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      );
    });
  }
}
