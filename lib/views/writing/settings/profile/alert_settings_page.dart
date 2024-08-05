import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';

class AlertSettings extends StatefulWidget {
  const AlertSettings({super.key});

  @override
  State<AlertSettings> createState() => _AlertSettingsState();
}

class _AlertSettingsState extends State<AlertSettings> {
  final WritingController _writingController = Get.find<WritingController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildSettingsAppBar(context, title: "Notifications"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding * 1.5, vertical: defaultPadding),
            decoration: const BoxDecoration(color: Colors.white),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: defaultPadding,
                ),
                Text(
                  "System Notifications",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                Text(
                  "Customize how you receive our notifications & latest news from us.",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: defaultPadding * 2,
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding * 1.5),
              child: ListView(
                children: [
                  FutureBuilder<bool>(
                      future: SharedPreferences.getInstance().then(
                          (preferences) =>
                              preferences.getBool("push_notifications") ??
                              true),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? AlertSettingsSwitch(
                                text: "Push Notifications",
                                value: snapshot.data!,
                                onChanged: (value) async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  preferences.setBool(
                                      "push_notifications", value);

                                  _writingController.updateUserAlertSettings({
                                    "push": value,
                                  });
                                },
                              )
                            : const SizedBox.shrink();
                      }),
                  FutureBuilder<bool>(
                      future: SharedPreferences.getInstance().then(
                          (preferences) =>
                              preferences.getBool("email_notifications") ??
                              true),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? AlertSettingsSwitch(
                                text: "Email Alerts",
                                value: snapshot.data!,
                                onChanged: (value) async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  preferences.setBool(
                                      "email_notifications", value);

                                  _writingController.updateUserAlertSettings({
                                    "email": value,
                                  });
                                },
                              )
                            : const SizedBox.shrink();
                      }),
                  FutureBuilder<bool>(
                      future: SharedPreferences.getInstance().then(
                          (preferences) =>
                              preferences.getBool("sms_notifications") ?? true),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? AlertSettingsSwitch(
                                text: "SMS",
                                value: snapshot.data ?? false,
                                onChanged: (value) async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  preferences.setBool(
                                      "sms_notifications", value);
                                  _writingController.updateUserAlertSettings({
                                    "sms": value,
                                  });
                                },
                              )
                            : const SizedBox.shrink();
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlertSettingsSwitch extends StatefulWidget {
  const AlertSettingsSwitch({
    super.key,
    required this.text,
    required this.value,
    required this.onChanged,
  });
  final String text;
  final bool value;
  final void Function(bool value) onChanged;

  @override
  State<AlertSettingsSwitch> createState() => _AlertSettingsSwitchState();
}

class _AlertSettingsSwitchState extends State<AlertSettingsSwitch> {
  late bool value;
  @override
  void initState() {
    setState(() {
      value = widget.value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: Row(
            children: [
              Text(
                widget.text,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Switch(
                value: value,
                activeColor: Colors.white,
                activeTrackColor: AppColors.buttonColor,
                inactiveTrackColor: Colors.grey.withOpacity(0.1),
                onChanged: (value_) {
                  widget.onChanged(value_);
                  setState(() {
                    value = value_;
                  });
                },
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey.withOpacity(0.2),
        ),
      ],
    );
  }
}
