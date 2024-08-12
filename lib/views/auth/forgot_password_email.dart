import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/authentication_controller.dart';
import 'package:word_and_learn/views/auth/otp_validation.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';

class ForgotPasswordEmailPage extends StatefulWidget {
  const ForgotPasswordEmailPage({super.key});

  @override
  State<ForgotPasswordEmailPage> createState() =>
      _ForgotPasswordEmailPageState();
}

class _ForgotPasswordEmailPageState extends State<ForgotPasswordEmailPage> {
  final TextEditingController emailTextController = TextEditingController();
  final AuthenticationController authenticationController =
      AuthenticationController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryContainer,
      appBar: buildSettingsAppBar(context, title: "Reset Your Password"),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter your email address to reset your password",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              AuthTextField(
                hintText: "Email Address",
                controller: emailTextController,
                keyboardType: TextInputType.emailAddress,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return "Email is required";
                  }
                  if (!p0.isEmail) {
                    return "Enter a valid email address";
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
                    authenticationController
                        .initiatePasswordReset(emailTextController.text)
                        .then(
                      (value) {
                        if (value.isSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("OTP Code Sent. Verify Code")));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OtpValidationPage(
                                        isPasswordReset: true,
                                      ),
                                  settings: const RouteSettings(
                                      name: "OtpValidationPage")));
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
                child: PrimaryButton(
                  color: AppColors.buttonColor,
                  child: loading
                      ? const LoadingSpinner(
                          size: 17,
                        )
                      : const Text(
                          "Send OTP Code",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
