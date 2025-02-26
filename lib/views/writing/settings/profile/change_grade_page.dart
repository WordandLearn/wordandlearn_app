import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';

class ChangeGradePage extends StatefulWidget {
  const ChangeGradePage({super.key});

  @override
  State<ChangeGradePage> createState() => _ChangeGradePageState();
}

class _ChangeGradePageState extends State<ChangeGradePage> {
  final TextEditingController gradeController = TextEditingController();
  final WritingController _writingController = Get.find<WritingController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? errorText;
  bool loading = false;

  void updateGrade() {
    setState(() {
      loading = true;
    });
    if (gradeController.text.isNotEmpty &&
        validator(gradeController.text) == null) {
      _writingController
          .updateChildProfileDetails({"grade": gradeController.text}).then(
        (value) {
          if (!context.mounted) {
            return;
          }
          if (value != null) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Row(
                children: [
                  Icon(
                    CupertinoIcons.check_mark_circled,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  Text("Grade Updated Successfully")
                ],
              )));
            }
          }
        },
      ).onError((error, stackTrace) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Row(
            children: [
              Icon(
                CupertinoIcons.xmark_circle_fill,
                color: Colors.red,
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Text("Failed to update Grade")
            ],
          )));
        }
      }).whenComplete(
        () {
          setState(() {
            loading = false;
          });
        },
      );
    }
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return "* Grade cannot be empty";
    }
    if (int.parse(value) < 1 || int.parse(value) > 12) {
      return "* Grade must be between 1 and 12";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildSettingsAppBar(context, title: "Change Your Grade"),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding * 2, vertical: defaultPadding),
        child: FutureBuilder<Profile?>(
            future: _writingController.getChildProfile(),
            builder: (context, snapshot) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding * 2,
                        horizontal: defaultPadding * 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "* This is a potentially dangerous action be careful.",
                          style: TextStyle(fontSize: 12),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "Current Grade: ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.greyTextColor),
                                  ),
                                  const SizedBox(
                                    height: defaultPadding / 2,
                                  ),
                                  Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: snapshot.hasData
                                              ? Text(
                                                  snapshot.data!.grade!
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      color: AppColors
                                                          .greyTextColor
                                                          .withOpacity(0.6)),
                                                )
                                              : const LoadingSpinner())),
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding * 2,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: defaultPadding * 2),
                                    child: SvgPicture.asset(
                                        "assets/icons/arrow-right-fill.svg"),
                                  )),
                              Column(
                                children: [
                                  const Text("New Grade: "),
                                  const SizedBox(
                                    height: defaultPadding / 2,
                                  ),
                                  SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Form(
                                        key: _formKey,
                                        child: AuthTextField(
                                          hintText: "",
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: gradeController,
                                          onChanged: (p0) {
                                            setState(() {
                                              errorText = validator(p0);
                                            });
                                          },
                                          paddiing: const EdgeInsets.symmetric(
                                              horizontal: defaultPadding,
                                              vertical: defaultPadding * 2),
                                          fillColor: Colors.white,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          textStyle: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                          child: errorText != null
                              ? Text(
                                  errorText!,
                                  style: const TextStyle(color: Colors.red),
                                )
                              : null,
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: gradeController.text.isNotEmpty
                              ? TapBounce(
                                  onTap: () {
                                    updateGrade();
                                  },
                                  child: PrimaryIconButton(
                                      text: "Change Grade",
                                      icon: loading
                                          ? const LoadingSpinner(
                                              size: 14,
                                            )
                                          : const Icon(
                                              CupertinoIcons.pencil,
                                              color: Colors.white,
                                              size: 17,
                                            )),
                                )
                              : const SizedBox.shrink(),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
