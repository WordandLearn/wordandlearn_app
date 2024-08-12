import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/auth_text_field.dart';
import 'package:word_and_learn/components/loading_spinner.dart';
import 'package:word_and_learn/components/primary_icon_button.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/views/auth/login.dart';
import 'package:word_and_learn/views/writing/lessons/lessons_page.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';
import 'package:word_and_learn/views/writing/settings/components/radio_input.dart';

class ProfileOnboardingPage extends StatefulWidget {
  const ProfileOnboardingPage({super.key});

  @override
  State<ProfileOnboardingPage> createState() => _ProfileOnboardingPageState();
}

class _ProfileOnboardingPageState extends State<ProfileOnboardingPage> {
  String gender = "M";
  DateTime? dateOfBirth;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  bool loading = false;
  final AuthenticationController authenticationController =
      AuthenticationController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSettingsAppBar(context, title: "Set Up Your Profile"),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding * 2),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding * 2),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Text("Personal Info",
                          //     style: TextStyle(
                          //         fontSize: 18, fontWeight: FontWeight.w600)),
                          // const SizedBox(
                          //   height: defaultPadding * 2,
                          // ),
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
                                      validator: (p0) {
                                        if (p0!.isEmpty) {
                                          return "First name is required";
                                        }
                                        return null;
                                      },
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
                                      validator: (p0) {
                                        if (p0!.isEmpty) {
                                          return "Last name is required";
                                        }
                                        return null;
                                      },
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
                                      lastDate: DateTime.now(),
                                      validator: (value) {
                                        if (value == null) {
                                          return "Date of birth is required";
                                        }
                                        if (DateTime.now().compareTo(value) ==
                                            -1) {
                                          return "Invalid date of birth";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: "",
                                          fillColor:
                                              AppColors.secondaryContainer,
                                          suffixIcon: const Icon(
                                              CupertinoIcons.calendar),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal:
                                                      defaultPadding * 3,
                                                  vertical: defaultPadding * 2),
                                          hintStyle: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                          filled: true,
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
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding),
                            child: Divider(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding * 2,
                                vertical: defaultPadding * 2),
                            decoration: BoxDecoration(
                                color: AppColors.secondaryContainer,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Your Grade",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                SizedBox(
                                  width: 120,
                                  child: AuthTextField(
                                    hintText: "2",
                                    controller: gradeController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    hintTextStyle:
                                        const TextStyle(fontSize: 12),
                                    textStyle: const TextStyle(
                                      fontSize: 22,
                                    ),
                                    validator: (p0) {
                                      if (p0!.isEmpty) {
                                        return "Required";
                                      }
                                      if (int.tryParse(p0) == null) {
                                        return "Invalid grade";
                                      }

                                      if (int.parse(p0) < 1 ||
                                          int.parse(p0) > 12) {
                                        return "Invalid grade";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                const Text(
                                  "Enter your correct grade. This may affect your learning experience",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.greyTextColor),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2,
                      vertical: defaultPadding * 4),
                  child: TapBounce(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        String dob =
                            DateFormat("yyyy-MM-d").format(dateOfBirth!);
                        Map<String, String> body = {
                          "name":
                              "${firstNameController.text} ${lastNameController.text}",
                          "date_of_birth": dob,
                          "grade": gradeController.text,
                          "gender": gender
                        };

                        authenticationController.createProfile(body).then(
                          (value) {
                            if (value.isSuccess) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Profile Set Up Successfully"),
                              ));
                              Get.put(WritingController());
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LessonsPage(),
                                      settings: const RouteSettings(
                                          name: "LessonsPage")));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "An error occurred check the values entered"),
                                backgroundColor: AppColors.redColor,
                              ));
                            }
                          },
                        ).whenComplete(
                          () {
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                      }
                    },
                    child: PrimaryIconButton(
                        text: "Setup Profile",
                        icon: loading
                            ? const LoadingSpinner(
                                size: 15,
                              )
                            : const Icon(
                                CupertinoIcons.cloud_upload,
                                color: Colors.white,
                                size: 17,
                              )),
                  ),
                )),
            Divider(
              color: Colors.grey.withOpacity(0.6),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: InkWell(
                onTap: () async {
                  authenticationController.logout().then(
                    (value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                            settings: const RouteSettings(name: "LoginPage"),
                          ));
                    },
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    Text(
                      "Back To Login",
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.buttonColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
