import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/authentication_controller.dart';
import 'package:word_and_learn/views/auth/login.dart';
import 'package:word_and_learn/views/auth/reset_password.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';

class OtpValidationPage extends StatefulWidget {
  const OtpValidationPage(
      {super.key, this.isPasswordReset = false, this.email});
  final bool isPasswordReset;

  final String? email;

  @override
  State<OtpValidationPage> createState() => _OtpValidationPageState();
}

class _OtpValidationPageState extends State<OtpValidationPage> {
  final TextEditingController otpTextController = TextEditingController();
  final AuthenticationController authenticationController =
      AuthenticationController();

  String? error;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildSettingsAppBar(context, title: "Verify OTP Code"),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: defaultPadding * 2, horizontal: defaultPadding * 2),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Verify the OTP Code sent to your email to continue",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Pinput(
                  length: 6,
                  controller: otpTextController,
                  errorText: error,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: defaultPadding * 2,
                ),
                error != null
                    ? Text(
                        error!,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            const Spacer(
              flex: 3,
            ),
            TapBounce(
                onTap: () {
                  if (otpTextController.length == 6) {
                    setState(() {
                      loading = true;
                    });
                    if (widget.isPasswordReset) {
                      authenticationController
                          .validateResetCode(otpTextController.text)
                          .then(
                        (value) {
                          if (value.isSuccess) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Code Verified, reset your password")));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResetPasswordPage(
                                        uid: value.data["uid"],
                                        token: value.data["token"]),
                                    settings: const RouteSettings(
                                        name: "ResetPasswordPage"),
                                  ));
                            }
                          } else {
                            setState(() {
                              error = value.data["error"];
                            });
                          }
                        },
                      ).whenComplete(
                        () {
                          setState(() {
                            loading = false;
                          });
                        },
                      );
                    } else {
                      assert(widget.email != null);
                      authenticationController
                          .activateEmail(widget.email!, otpTextController.text)
                          .then(
                        (value) {
                          if (value.isSuccess) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Account Activated. You can now log in")));
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ));
                            }
                          } else {
                            setState(() {
                              error = value.data["error"];
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Code is invalid or expired")));
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
                  }
                },
                child: PrimaryButton(
                  color: AppColors.buttonColor,
                  child: loading
                      ? const LoadingSpinner(
                          size: 17,
                        )
                      : const Text(
                          "Verify OTP",
                          style: TextStyle(color: Colors.white),
                        ),
                ))
          ],
        ),
      ),
    );
  }
}
