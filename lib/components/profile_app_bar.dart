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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(defaultImageUrl),
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            Text(
              "Hello",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Arabella",
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
        SvgPicture.asset(
          "assets/icons/menu.svg",
          height: 40,
          width: 50,
        )
      ],
    );
  }
}
