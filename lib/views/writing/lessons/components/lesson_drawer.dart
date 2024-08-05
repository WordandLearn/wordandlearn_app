import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/circle_profile_avatar.dart';
import 'package:word_and_learn/components/primary_icon_button.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/views/auth/login.dart';
import 'package:word_and_learn/views/writing/settings/profile/alert_settings_page.dart';
import 'package:word_and_learn/views/writing/settings/profile/profile_settings.dart';
import 'package:word_and_learn/views/writing/settings/profile/subscription_settings.dart';

class LessonDrawer extends StatefulWidget {
  const LessonDrawer({super.key, required this.onClose});
  final void Function() onClose;

  @override
  State<LessonDrawer> createState() => _LessonDrawerState();
}

class _LessonDrawerState extends State<LessonDrawer> {
  final WritingController writingController = Get.find<WritingController>();

  late Future<Profile?> _profileFuture;

  @override
  void initState() {
    _profileFuture = writingController.getChildProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            FutureBuilder<Profile?>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleProfileAvatar(),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                key: ValueKey<bool>(snapshot.hasData),
                                child: Builder(
                                  builder: (context) {
                                    if (snapshot.hasData) {
                                      return SizedBox(
                                        width: 150,
                                        child: Text(
                                          snapshot.data!.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      );
                                    }
                                    return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 100,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ));
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding / 3,
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Builder(
                                    key: ValueKey<bool>(snapshot.hasData),
                                    builder: (context) {
                                      if (snapshot.hasData) {
                                        return Text(
                                            "Grade ${snapshot.data!.grade}");
                                      } else {
                                        return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              width: 60,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                            ));
                                      }
                                    }),
                              )
                            ],
                          )
                        ],
                      ),
                      InkWell(
                        onTap: widget.onClose,
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                shape: BoxShape.circle),
                            padding: const EdgeInsets.all(defaultPadding / 4),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 20,
                            )),
                      )
                    ],
                  );
                }),
            const SizedBox(
              height: defaultPadding,
            ),
            Divider(
              color: AppColors.inactiveColor.withOpacity(0.3),
            )
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Account Settings",
                      style: TextStyle(
                          color: AppColors.inactiveColor, fontSize: 14),
                    ),
                    Divider(color: AppColors.inactiveColor.withOpacity(0.2)),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    _DrawerTile(
                      icon: const Icon(CupertinoIcons.person),
                      title: "My Profile",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return const ProfileSettings();
                                },
                                settings: const RouteSettings(
                                    name: "ProfileSettings")));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Subscription & Payments",
                      style: TextStyle(
                          color: AppColors.inactiveColor, fontSize: 14),
                    ),
                    Divider(color: AppColors.inactiveColor.withOpacity(0.2)),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    _DrawerTile(
                      icon: const Icon(CupertinoIcons.creditcard),
                      title: "My Subscription",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return const SubscriptionSettings();
                                },
                                settings: const RouteSettings(
                                    name: "SubscriptionSettings")));
                      },
                    ),
                    const SizedBox(
                      height: defaultPadding * 2,
                    ),
                    _DrawerTile(
                      icon: const Icon(Icons.wallet_outlined),
                      title: "Payment Methods",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return const SubscriptionSettings();
                                },
                                settings: const RouteSettings(
                                    name: "SubscriptionSettings")));
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Alerts",
                        style: TextStyle(
                            color: AppColors.inactiveColor, fontSize: 14),
                      ),
                      Divider(color: AppColors.inactiveColor.withOpacity(0.2)),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      _DrawerTile(
                        icon: const Icon(CupertinoIcons.bell),
                        title: "Notifications",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AlertSettings(),
                                  settings: const RouteSettings(
                                      name: "AlertSettings")));
                        },
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Privacy",
                      style: TextStyle(
                          color: AppColors.inactiveColor, fontSize: 14),
                    ),
                    Divider(color: AppColors.inactiveColor.withOpacity(0.2)),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    _DrawerTile(
                      icon: const Icon(CupertinoIcons.doc_plaintext),
                      title: "Terms of Use",
                      onTap: () {},
                    ),
                    const SizedBox(
                      height: defaultPadding * 2,
                    ),
                    _DrawerTile(
                      icon: const Icon(CupertinoIcons.doc_text),
                      title: "Privacy Policy",
                      onTap: () {},
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Talk to Us",
                        style: TextStyle(
                            color: AppColors.inactiveColor, fontSize: 14),
                      ),
                      Divider(color: AppColors.inactiveColor.withOpacity(0.2)),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      _DrawerTile(
                        icon: const Icon(CupertinoIcons.mail),
                        title: "Contact Us",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        TapBounce(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text(
                      "Logout",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.black),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                writingController.logout().then((value) {
                                  Get.delete<WritingController>();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                    (route) => false,
                                  );
                                });
                              },
                              child: const Text(
                                "Logout",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600),
                              ))
                        ],
                      ),
                    ],
                  );
                });
          },
          child: const PrimaryIconButton(
            text: "Logout",
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 15,
            ),
            color: AppColors.redColor,
          ),
        )
      ],
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final Widget icon;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
        child: Row(
          key: key,
          children: [
            icon,
            const SizedBox(
              width: defaultPadding,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor),
            )
          ],
        ),
      ),
    );
  }
}
