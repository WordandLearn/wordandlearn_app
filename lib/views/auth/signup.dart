import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/authentication_controller.dart';
import 'package:word_and_learn/views/auth/login.dart';
import 'package:word_and_learn/views/auth/otp_validation.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
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
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: SizedBox(
            height: size.height,
            width: constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
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
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
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
                        controller: emailController,
                        hintText: "Email Address",
                        keyboardType: TextInputType.emailAddress,
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return "Email cannot be empty";
                          }
                          if (!p0.isEmail) {
                            return "Invalid Email Address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: defaultPadding * 2,
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
                      const SizedBox(
                        height: defaultPadding * 2,
                      ),
                      AuthTextField(
                        controller: passwordConfirmController,
                        hintText: "Confirm Password",
                        maxLines: 1,
                        obscureText: true,
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return "Password cannot be empty";
                          }
                          if (p0 != passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: defaultPadding * 2),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () async {
                        await launchUrl(Uri.parse(tosUrl));
                      },
                      child: const Text(
                        "By signing up you agree to our terms of service",
                        style: TextStyle(
                            fontSize: 12, color: AppColors.greyTextColor),
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
                      setState(() {
                        error = null;
                      });
                      toggleLoading();
                      Map<String, String> body = {
                        "email": emailController.text,
                        "password1": passwordController.text,
                        "password2": passwordConfirmController.text
                      };
                      authenticationController.signUp(body).then(
                        (response) {
                          if (response.isSuccess) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Verify your email address to continue")));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtpValidationPage(
                                          email: emailController.text),
                                      settings: const RouteSettings(
                                          name: "OtpValidationPage")));
                            }
                          } else {
                            setState(() {
                              error = response.errors?.join("\n").capitalize;
                            });
                          }
                        },
                      ).whenComplete(
                        () {
                          toggleLoading();
                        },
                      );
                    }
                  },
                  child: PrimaryIconButton(
                      text: "Sign Up",
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
                  padding:
                      const EdgeInsets.symmetric(vertical: defaultPadding * 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Have An Account?",
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
                                    return const LoginPage();
                                  },
                                  settings:
                                      const RouteSettings(name: "LoginPage")));
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
