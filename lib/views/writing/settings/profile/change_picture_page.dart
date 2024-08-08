import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/writing/models.dart';

class ChangePicturePage extends StatefulWidget {
  const ChangePicturePage({super.key});

  @override
  State<ChangePicturePage> createState() => _ChangePicturePageState();
}

class _ChangePicturePageState extends State<ChangePicturePage> {
  final WritingController _writingController = Get.find<WritingController>();

  final ImagePicker _picker = ImagePicker();
  bool uploading = false;
  File? selectedFile;

  void pickImage() async {
    XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        selectedFile = File(imageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding * 2),
        child: FutureBuilder<ProfilePicture?>(
            future: _writingController.getProfilePicture(),
            builder: (context, snapshot) {
              return Column(
                children: [
                  const Text(
                    "Update Profile Picture",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding * 5),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.buttonColor, width: 2),
                            shape: BoxShape.circle),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: CircleAvatar(
                              key: ValueKey<bool>(selectedFile != null),
                              radius: 100,
                              backgroundImage: selectedFile != null
                                  ? Image.file(selectedFile!).image
                                  : CachedNetworkImageProvider(snapshot.hasData
                                      ? snapshot.data!.imageUrl
                                      : defaultImageUrl)),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      snapshot.hasData || selectedFile != null
                          ? Expanded(
                              flex: 2,
                              child: TapBounce(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: const Text(
                                            "Remove Profile Picture",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                          content: const Text(
                                              "Do you want to delete your profile picture"),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      if (selectedFile !=
                                                          null) {
                                                        setState(() {
                                                          selectedFile = null;
                                                        });
                                                      } else {
                                                        _writingController
                                                            .removeProfilePicture()
                                                            .then(
                                                          (value) {
                                                            setState(() {
                                                              selectedFile =
                                                                  null;
                                                            });
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: const Text(
                                                      "Remove",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ))
                                              ],
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: PrimaryButton(
                                    color: Colors.grey.withOpacity(0.3),
                                    child: const Text(
                                      "Remove Photo",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ))
                          : const SizedBox.shrink(),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(
                          flex: 3,
                          child: TapBounce(
                            onTap: () async {
                              if (selectedFile != null) {
                                setState(() {
                                  uploading = true;
                                });
                                _writingController
                                    .addProfilePicture(selectedFile!)
                                    .onError(
                                  (error, stackTrace) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            content: Row(
                                      children: [
                                        Icon(
                                          Icons.error,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Could not upload profile picture",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )));
                                    return null;
                                  },
                                ).then(
                                  (value) {
                                    if (value != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Row(
                                        children: [
                                          Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Profile Picture Updated",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )));
                                    }
                                  },
                                ).whenComplete(() {
                                  setState(() {
                                    uploading = false;
                                  });
                                });
                              } else {
                                pickImage();
                              }
                            },
                            child: PrimaryButton(
                                color: AppColors.buttonColor,
                                child: !uploading
                                    ? Text(
                                        selectedFile != null
                                            ? "Upload Picture"
                                            : snapshot.hasData
                                                ? "Change Picture"
                                                : "Add Picture",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : const LoadingSpinner()),
                          ))
                    ],
                  )
                ],
              );
            }),
      ),
    );
  }
}
