import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/circle_profile_avatar.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';
import 'package:word_and_learn/views/writing/settings/components/radio_input.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String gender = "M";
  ChildProfileDetails? childProfileDetails;
  DateTime? dateOfBirth;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final WritingController _writingController = Get.find<WritingController>();
  bool loading = false;
  updateValues(ChildProfileDetails value) {
    setState(() {
      childProfileDetails = value;
      firstNameController.text = childProfileDetails!.name.split(" ")[0];
      lastNameController.text = childProfileDetails!.name.split(" ")[1];
      gender = childProfileDetails!.gender;
      dateOfBirth = childProfileDetails!.dateOfBirth;
    });
  }

  @override
  void initState() {
    _writingController.getChildProfileDetails().then((value) {
      if (value != null) {
        updateValues(value);
      }
    });
    super.initState();
  }

  String? validator() {
    if (firstNameController.text.isEmpty) {
      return "First Name cannot be empty";
    }
    if (lastNameController.text.isEmpty) {
      return "Last Name cannot be empty";
    }
    if (dateOfBirth == null) {
      return "Date of Birth cannot be empty";
    }
    return null;
  }

  void updateProfile() {
    String? error = validator();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
        children: [
          const Icon(
            CupertinoIcons.xmark_circle_fill,
            color: Colors.red,
          ),
          const SizedBox(
            width: defaultPadding,
          ),
          Text(
            error,
            style: const TextStyle(color: Colors.red),
          )
        ],
      )));
      return;
    }

    setState(() {
      loading = true;
    });

    Map<String, dynamic> body = {
      "name": "${firstNameController.text} ${lastNameController.text}",
      "date_of_birth": DateFormat("yyyy-MM-dd").format(dateOfBirth!).toString(),
      "gender": gender,
    };
    _writingController.updateChildProfileDetails(body).then((value) {
      if (value != null) {
        updateValues(value);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Row(
            children: [
              Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: Colors.green,
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Text(
                "Profile Updated Successfully",
                style: TextStyle(color: Colors.green),
              )
            ],
          )));
        }
      }
    }).onError((error, stackTrace) {
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
            Text(
              "Could not Update Profile",
              style: TextStyle(color: Colors.red),
            )
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSettingsAppBar(context, title: "Edit Your Profile"),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            )
                          ]),
                    ),
                    const CircleProfileAvatar(
                      radius: 40,
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: defaultPadding * 2),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "First Name",
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                AuthTextField(
                                  hintText: "",
                                  controller: firstNameController,
                                  fillColor: AppColors.secondaryContainer,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: defaultPadding * 2,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Last Name",
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                AuthTextField(
                                  hintText: "",
                                  controller: lastNameController,
                                  fillColor: AppColors.secondaryContainer,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Date of Birth",
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(
                                height: defaultPadding / 2,
                              ),
                              DateTimeFormField(
                                  mode: DateTimeFieldPickerMode.date,
                                  onChanged: (date) {
                                    setState(() {
                                      dateOfBirth = date;
                                    });
                                  },
                                  initialValue: dateOfBirth,
                                  materialDatePickerOptions:
                                      const MaterialDatePickerOptions(
                                          initialEntryMode:
                                              DatePickerEntryMode.input,
                                          initialDatePickerMode:
                                              DatePickerMode.day),
                                  decoration: InputDecoration(
                                      hintText: "",
                                      suffixIcon:
                                          const Icon(CupertinoIcons.calendar),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: defaultPadding * 3,
                                              vertical: defaultPadding * 2),
                                      hintStyle: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                      filled: true,
                                      fillColor: AppColors.secondaryContainer,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.buttonColor,
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                            ],
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Gender",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(
                            height: defaultPadding / 2,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: TapBounce(
                                onTap: () {
                                  setState(() {
                                    gender = "M";
                                  });
                                },
                                child: RadioInput(
                                  label: "Male",
                                  isActive: gender == "M",
                                ),
                              )),
                              const SizedBox(
                                width: defaultPadding * 2,
                              ),
                              Expanded(
                                  child: TapBounce(
                                onTap: () {
                                  setState(() {
                                    gender = "F";
                                  });
                                },
                                child: RadioInput(
                                  label: "Female",
                                  isActive: gender == "F",
                                ),
                              ))
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: childProfileDetails != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding * 2,
                        vertical: defaultPadding * 4),
                    child: TapBounce(
                      onTap: () {
                        updateProfile();
                      },
                      child: PrimaryIconButton(
                          text: "Update Profile",
                          icon: loading
                              ? const LoadingSpinner(
                                  size: 15,
                                )
                              : const Icon(
                                  CupertinoIcons.pencil,
                                  color: Colors.white,
                                  size: 17,
                                )),
                    ),
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
