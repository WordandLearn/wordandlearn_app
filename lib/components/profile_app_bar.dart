import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:word_and_learn/constants/constants.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          "assets/icons/menu.svg",
          height: 40,
          width: 50,
        ),
        const CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(defaultImageUrl),
          radius: 20,
        ),
      ],
    );
  }
}
