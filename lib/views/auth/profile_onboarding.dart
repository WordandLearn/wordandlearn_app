import 'package:flutter/material.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';

class ProfileOnboardingPage extends StatelessWidget {
  const ProfileOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSettingsAppBar(context, title: "Set Up Your Profile"),
    );
  }
}
