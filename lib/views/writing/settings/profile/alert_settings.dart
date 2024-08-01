import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';

class AlertSettings extends StatelessWidget {
  const AlertSettings({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: Fetch Values from Backend Server and Update also backend
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildSettingsAppBar(context, title: "Notifications"),
      body: Column(
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
                  AlertSettingsSwitch(
                    text: "Push Notifications",
                    value: true,
                    onChanged: (value) async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.setBool("push_notifications", value);
                    },
                  ),
                  AlertSettingsSwitch(
                    text: "Email Alerts",
                    value: true,
                    onChanged: (value) async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.setBool("email_notifications", value);
                    },
                  ),
                  AlertSettingsSwitch(
                    text: "SMS",
                    value: false,
                    onChanged: (value) async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.setBool("sms_notifications", value);
                    },
                  ),
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
  late ValueNotifier<bool> _valueNotifier;
  @override
  void initState() {
    _valueNotifier = ValueNotifier<bool>(widget.value);
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
              AdvancedSwitch(
                controller: _valueNotifier,
                height: 25,
                width: 40,
                onChanged: (value) {
                  setState(() {
                    _valueNotifier.value = value;
                    widget.onChanged(value);
                  });
                },
                activeColor: AppColors.buttonColor,
                disabledOpacity: 0.2,
                enabled: true,
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
