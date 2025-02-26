import 'package:flutter/material.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.uid, required this.token});
  final String uid;
  final String token;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthenticationController authenticationController =
      AuthenticationController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryContainer,
      appBar: buildSettingsAppBar(context, title: 'Reset Your Password'),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Your New Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: defaultPadding * 2,
              ),
              AuthTextField(
                hintText: "Password",
                obscureText: true,
                maxLines: 1,
                controller: passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password cannot be empty";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: defaultPadding * 3,
              ),
              AuthTextField(
                hintText: "Confirm Password",
                obscureText: true,
                maxLines: 1,
                controller: confirmPasswordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password cannot be empty";
                  }
                  if (value != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const Spacer(),
              TapBounce(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    Map<String, String> body = {
                      "password1": passwordController.text,
                      "password2": confirmPasswordController.text
                    };

                    authenticationController
                        .resetPassword(
                            token: widget.token, uid: widget.uid, body: body)
                        .then(
                      (value) {
                        if (context.mounted) {
                          if (value.isSuccess) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Password reset successfully"),
                              backgroundColor: Colors.green,
                            ));
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Password reset failed"),
                              backgroundColor: Colors.red,
                            ));
                          }
                        }
                      },
                    ).whenComplete(
                      () {
                        setState(() {
                          loading = false;
                        });
                      },
                    );
                    // Reset Password
                  }
                },
                child: PrimaryIconButton(
                    text: "Reset Password",
                    icon: loading
                        ? const LoadingSpinner(
                            size: 17,
                          )
                        : const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                            size: 17,
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
