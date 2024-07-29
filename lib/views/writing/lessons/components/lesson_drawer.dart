import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/primary_icon_button.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/views/auth/login.dart';

class LessonDrawer extends StatefulWidget {
  const LessonDrawer({super.key, required this.onClose});
  final void Function() onClose;

  @override
  State<LessonDrawer> createState() => _LessonDrawerState();
}

class _LessonDrawerState extends State<LessonDrawer> {
  final WritingController writingController = Get.find<WritingController>();
  Future<String> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String name = preferences.getString("name") ?? "";
    return name;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        defaultImageUrl,
                      ),
                      radius: 20,
                    ),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String>(
                          future: getName(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
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
                                      borderRadius: BorderRadius.circular(20)),
                                ));
                          },
                        ),
                        const Text(
                          "Nova Pioneer",
                          style: TextStyle(
                              color: AppColors.inactiveColor, fontSize: 12),
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
            ),
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
                      onTap: () {},
                    ),
                    const SizedBox(
                      height: defaultPadding * 2,
                    ),
                    _DrawerTile(
                      icon: SvgPicture.asset(
                        "assets/icons/account.svg",
                        height: 20,
                      ),
                      title: "My Account",
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
                        "Notifications",
                        style: TextStyle(
                            color: AppColors.inactiveColor, fontSize: 14),
                      ),
                      Divider(color: AppColors.inactiveColor.withOpacity(0.2)),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      _DrawerTile(
                        icon: const Icon(CupertinoIcons.bell),
                        title: "Push Notifications",
                        onTap: () {},
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
