import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/writing_controller.dart';
import 'package:word_and_learn/models/models.dart';

class CircleProfileAvatar extends StatefulWidget {
  const CircleProfileAvatar({
    super.key,
    this.radius = 20,
  });

  final double radius;

  @override
  State<CircleProfileAvatar> createState() => _CircleProfileAvatarState();
}

class _CircleProfileAvatarState extends State<CircleProfileAvatar> {
  late Future<ProfilePicture?> _future;
  final WritingController writingController = Get.find<WritingController>();
  @override
  void initState() {
    _future = writingController.getProfilePicture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfilePicture?>(
        future: _future,
        builder: (context, snapshot_) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Builder(
                key: ValueKey<bool>(snapshot_.hasData),
                builder: (context) {
                  if (snapshot_.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: widget.radius * 2,
                          height: widget.radius * 2,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        ));
                  }
                  if (snapshot_.hasData) {
                    return CircleAvatar(
                      radius: widget.radius,
                      backgroundColor: Colors.transparent,
                      backgroundImage: CachedNetworkImageProvider(
                          snapshot_.data!.thumbnailUrl),
                    );
                  }
                  return CircleAvatar(
                    radius: widget.radius,
                    backgroundImage:
                        const CachedNetworkImageProvider(defaultImageUrl),
                  );
                }),
          );
        });
  }
}
