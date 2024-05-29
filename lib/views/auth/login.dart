import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/authentication_controller.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/home/module_selection.dart';
import 'package:word_and_learn/views/writing/lessons/lessons_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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
      // bottomImage: Image.asset(
      //   "assets/images/joyful_kids.png",
      //   height: size.height * 0.15,
      // ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.1),
            child: const Center(
              child: LogoType(
                width: 200,
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
                  //TODO: FORGOT PASSWORD FUNCTION
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
          PrimaryButton(
            isLoading: isLoading,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                toggleLoading();
                authenticationController
                    .login(usernameController.text, passwordController.text)
                    .then((HttpResponse response) {
                  if (response.isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      "That was a success :)",
                      style: TextStyle(color: Colors.green),
                    )));
                    Get.put(WritingController());

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LessonsPage(),
                        ));
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
            child: const Text(
              "GO",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't Have An Account?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: defaultPadding / 2,
                ),
                Text(
                  "Sign Up",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
