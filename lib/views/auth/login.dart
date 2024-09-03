import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/authentication_controller.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/views/auth/forgot_password_email.dart';
import 'package:word_and_learn/views/auth/profile_onboarding.dart';
import 'package:word_and_learn/views/auth/signup.dart';
import 'package:word_and_learn/views/writing/lessons/lessons_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthenticationController authenticationController =
      AuthenticationController();

  bool isLoading = false;
  String? error;

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      backgroundColor: const Color(0xFFF8F5FE),

      // bottomImage: Image.asset(
      //   "assets/images/joyful_kids.png",
      //   height: size.height * 0.15,
      // ),
      body: SizedBox(
        height: size.height,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.1),
              child: const Center(
                child: LogoType(
                  width: 150,
                ),
              ),
            ),
            error != null
                ? Padding(
                    padding: allPadding * 2,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_rounded,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Text(
                          error!,
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AuthTextField(
                    controller: usernameController,
                    hintText: "Username",
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return "Username cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: defaultPadding * 3,
                  ),
                  AuthTextField(
                    controller: passwordController,
                    hintText: "Password",
                    maxLines: 1,
                    obscureText: true,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return "Password cannot be empty";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ForgotPasswordEmailPage(),
                            settings: const RouteSettings(
                                name: "ForgotPasswordEmailPage")));
                  },
                  child: Text(
                    "Forgot Password?",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: defaultPadding * 0.1,
            ),
            TapBounce(
              scale: 0.99,
              duration: const Duration(milliseconds: 150),
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  toggleLoading();
                  authenticationController
                      .login(usernameController.text, passwordController.text)
                      .then((HttpResponse response) {
                    if (response.isSuccess) {
                      if (response.data["user"]["profile"] == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return const ProfileOnboardingPage();
                                },
                                settings: const RouteSettings(
                                    name: "ProfileOnboardingPage")));
                      } else {
                        if (response.data["user"]["role"] != "C") {
                          setState(() {
                            error = "Only students can login here";
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                            "Only students can login here",
                            style: TextStyle(color: Colors.red),
                          )));
                          return;
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                            "That was a success :)",
                            style: TextStyle(color: Colors.green),
                          )));
                          Get.put(WritingController());

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LessonsPage(),
                                  settings: const RouteSettings(
                                      name: "LessonsPage")));
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                        "An error has occured :()",
                        style: TextStyle(color: Colors.red),
                      )));
                      setState(() {
                        error = response.data['error'];
                      });
                    }
                  }).whenComplete(() => toggleLoading());
                }
              },
              child: PrimaryIconButton(
                  text: "Login",
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: !isLoading
                        ? const Icon(
                            Icons.login_rounded,
                            color: Colors.white,
                            size: 15,
                          )
                        : const LoadingSpinner(
                            size: 15,
                          ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding * 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't Have An Account?",
                      style: TextStyle(
                          fontSize: 14, color: AppColors.greyTextColor)),
                  const SizedBox(
                    width: defaultPadding / 2,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) {
                                return const SignUpPage();
                              },
                              settings:
                                  const RouteSettings(name: "SignUpPage")));
                    },
                    child: const Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
