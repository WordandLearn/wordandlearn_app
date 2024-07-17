import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:word_and_learn/constants/constants.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key, this.onMenuPressed, this.onProfilePressed});
  final void Function()? onMenuPressed;
  final void Function()? onProfilePressed;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 40,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        child: GestureDetector(
          onTap: onMenuPressed,
          child: SvgPicture.asset(
            "assets/icons/menu.svg",
            width: 25,
          ),
        ),
      ),
      actions: [
        Image.asset(
          "assets/logo/Logotype.png",
          width: 90,
        ),
        InkWell(
          onTap: onProfilePressed,
          child: const CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(defaultImageUrl),
            radius: 15,
          ),
        ),
      ],
    );
  }
}
