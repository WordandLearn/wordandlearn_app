import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/circle_profile_avatar.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/writing/settings/components/build_settings_app_bar.dart';
import 'package:word_and_learn/views/writing/settings/profile/change_picture_page.dart';
import 'package:word_and_learn/views/writing/settings/profile/edit_profile_page.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late Future<Profile?> _future;
  final WritingController writingController = Get.find<WritingController>();
  @override
  void initState() {
    _future = writingController.getChildProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile?>(
        future: _future,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: buildSettingsAppBar(context, title: "Profile Settings"),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2, vertical: defaultPadding),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border.symmetric(
                          vertical: BorderSide(color: Colors.grey))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleProfileAvatar(
                            radius: 25,
                          ),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          Builder(builder: (context) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                snapshot.hasData
                                    ? Text(
                                        snapshot.data!.name,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          height: 10,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        )),
                                const SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                snapshot.hasData
                                    ? snapshot.data!.grade != null
                                        ? Text(
                                            "Grade ${snapshot.data!.grade}",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          )
                                        : const SizedBox.shrink()
                                    : Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          height: 10,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        )),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(
                        height: defaultPadding * 2,
                      ),
                      SizedBox(
                        width: 150,
                        child: TapBounce(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfilePage(),
                                    settings: const RouteSettings(
                                        name: "EditProfilePage")));
                          },
                          child: const PrimaryButton(
                            color: AppColors.buttonColor,
                            borderRadius: 40,
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Profile",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Column(
                                children: [
                                  SettingsListItem(
                                      text: "Update Profile Picture",
                                      icon: const Icon(
                                        CupertinoIcons.photo_camera,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return const SizedBox(
                                                  height: 350,
                                                  child: ChangePicturePage());
                                            });
                                      }),
                                  SettingsListItem(
                                      text: "Link To Your School",
                                      icon: const Icon(
                                        CupertinoIcons.link,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        //TODO: Show that this is coming school
                                      }),
                                  SettingsListItem(
                                      text: "Change Your Grade",
                                      iconBackgroundColor:
                                          Colors.red.withOpacity(0.1),
                                      icon: const Icon(
                                        CupertinoIcons.refresh,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      textStyle: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600),
                                      onPressed: () {
                                        //TODO: Implement change your grade option
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Account",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Column(
                                children: [
                                  SettingsListItem(
                                    text: "Update Email Address",
                                    onPressed: () {
                                      //TODO: Implement Email Address Update
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.mail,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SettingsListItem(
                                      text: "Change Password",
                                      icon: const Icon(
                                        CupertinoIcons.padlock,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        //TODO: Implement Password Change
                                      }),
                                  SettingsListItem(
                                      text: "Request Your Data",
                                      icon: const Icon(
                                        CupertinoIcons.archivebox,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        //TODO: Implement Request Data
                                      }),
                                  SettingsListItem(
                                      text: "Disable or Delete Your Account",
                                      iconBackgroundColor:
                                          Colors.red.withOpacity(0.2),
                                      textStyle: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600),
                                      icon: const Icon(
                                        CupertinoIcons.delete,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        //TODO: Implement Account Deletion
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class SettingsListItem extends StatelessWidget {
  const SettingsListItem({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.textStyle,
    this.iconBackgroundColor,
  });

  final String text;
  final void Function() onPressed;
  final Widget? icon;
  final TextStyle? textStyle;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: TapBounce(
        scale: 0.99,
        duration: const Duration(milliseconds: 150),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: defaultPadding * 2, horizontal: defaultPadding),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.2))),
          child: Row(
            children: [
              const SizedBox(
                width: defaultPadding,
              ),
              Row(
                children: [
                  icon ?? const SizedBox.shrink(),
                  SizedBox(
                    width: icon != null ? defaultPadding : 0,
                  ),
                  Text(
                    text,
                    style: textStyle ??
                        const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: textStyle?.color,
              )
            ],
          ),
        ),
      ),
    );
  }
}
