import 'package:cross_file/cross_file.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/utils/file_utils.dart';
import 'package:word_and_learn/views/writing/upload/composition_waiting_page.dart';

class CompositionUploadPage extends StatefulWidget {
  const CompositionUploadPage({super.key, required this.images});
  final List<XFile> images;

  @override
  State<CompositionUploadPage> createState() => _CompositionUploadPageState();
}

class _CompositionUploadPageState extends State<CompositionUploadPage> {
  int activeIndex = 0;
  bool uploading = false;

  late List<XFile> images;

  @override
  void initState() {
    setState(() {
      images = widget.images;
    });
    super.initState();
  }

  void _retake() async {
    if (kIsWeb) {
      List<XFile>? selectedFiles = await FileUtils.pickFilesWeb();
      if (selectedFiles != null) {
        setState(() {
          images = selectedFiles;
        });
      }
    } else {
      List<String?>? paths = await CunningDocumentScanner.getPictures(
          isGalleryImportAllowed: true, noOfPages: 2);

      if (paths != null) {
        setState(() {
          images = paths.map((e) => XFile(e!)).toList();
        });
      }
    }
  }

  final WritingController writingController = Get.find<WritingController>();

  void _uploadComposition(List<XFile> images) {
    if (!uploading) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context_) {
            return AlertDialog(
              actions: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TapBounce(
                        onTap: () {
                          Navigator.pop(context_);
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.close_rounded,
                              color: Colors.red,
                            ),
                            Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      TapBounce(
                        onTap: () async {
                          setState(() {
                            uploading = true;
                          });
                          Navigator.pop(context);

                          writingController.uploadComposition(images).then(
                            (value) {
                              if (context.mounted) {
                                if (value.isSuccess) {
                                  if (context.mounted) {
                                    showModalBottomSheet(
                                        context: context,
                                        isDismissible: false,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return SizedBox(
                                            child: CompositionWaitingPage(
                                                taskId: value.data['task_id']),
                                          );
                                        });
                                  }
                                }
                              } else {
                                if (value.statusCode == 400) {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Error",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Text(
                                            value.data["error"]["message"],
                                            style: const TextStyle(
                                                fontSize: 16, height: 2),
                                          ),
                                          actions: [
                                            TapBounce(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _retake();
                                                },
                                                child: const PrimaryIconButton(
                                                    text: "Retake Submission",
                                                    icon: Icon(
                                                      CupertinoIcons.refresh,
                                                      color: Colors.white,
                                                    )))
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              }
                            },
                          ).whenComplete(
                            () async {
                              setState(() {
                                uploading = false;
                              });
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.setBool(
                                  'uploadOnboarded', true);
                            },
                          );
                        },
                        child: const PrimaryIconButton(
                            text: "Confirm",
                            icon: Icon(
                              Icons.done_rounded,
                              color: Colors.white,
                            )),
                      )
                    ]),
              ],
              content: const Text(
                  "Make sure everything is clear before uploading your composition."),
              title: const Text(
                "Ready to Upload?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.secondaryColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context)),
          title: const Text(
            'Upload Composition',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Builder(builder: (context) {
                return Column(
                  children: [
                    Expanded(
                      child: images.isNotEmpty
                          ? Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  key: ValueKey<String>(
                                      images[activeIndex].path),
                                  child: FutureBuilder<Uint8List>(
                                      future: images[activeIndex].readAsBytes(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Image.memory(
                                            snapshot.data!,
                                            // width: 200,
                                            height: size.height * 0.6,
                                          );
                                        }
                                        return const LoadingSpinner();
                                      }),
                                ),
                              ),
                            )
                          : const SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child:
                                          Text("No image has been submitted")),
                                ],
                              ),
                            ),
                    ),
                    images.length > 1
                        ? Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: defaultPadding),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              width: size.width * 0.65,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding,
                                  vertical: defaultPadding),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    images.length,
                                    (index) => InkWell(
                                          onTap: () {
                                            setState(() {
                                              activeIndex = index;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: defaultPadding / 2),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            decoration: BoxDecoration(
                                                border: activeIndex == index
                                                    ? Border.all(
                                                        color: AppColors
                                                            .buttonColor,
                                                        width: 2)
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: FutureBuilder<Uint8List>(
                                                    future: images[activeIndex]
                                                        .readAsBytes(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Image.memory(
                                                          snapshot.data!,

                                                          // width: 200,
                                                          height:
                                                              size.height * 0.1,
                                                        );
                                                      }
                                                      return const LoadingSpinner();
                                                    })),
                                          ),
                                        )),
                              ),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                );
              }),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding * 1.5,
                  horizontal: defaultPadding * 2),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              child: LayoutBuilder(builder: (context, constraints) {
                return Center(
                  child: SizedBox(
                    width:
                        constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
                    child: Column(
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: defaultPadding),
                          child: Text(
                            "Confirm your composition before uploading",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: TapBounce(
                                  onTap: _retake,
                                  scale: 1.001,
                                  child: const Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.refresh_bold,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: defaultPadding / 2,
                                      ),
                                      Text(
                                        "Retake",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                )),
                            images.isNotEmpty
                                ? const Spacer(
                                    flex: 1,
                                  )
                                : const SizedBox.shrink(),
                            images.isNotEmpty
                                ? Expanded(
                                    flex: 4,
                                    child: AnimatedSize(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: TapBounce(
                                        scale: 1.01,
                                        onTap: () {
                                          _uploadComposition(images);
                                        },
                                        curve: Curves.bounceInOut,
                                        child: PrimaryButton(
                                          color: AppColors.buttonColor,
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: Row(
                                              key: ValueKey<bool>(uploading),
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  !uploading
                                                      ? "Upload"
                                                      : "Uploading...",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(
                                                  width: defaultPadding,
                                                ),
                                                Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.white
                                                          .withOpacity(0.1)),
                                                  child: Center(
                                                    child: AnimatedSwitcher(
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      switchInCurve:
                                                          Curves.easeIn,
                                                      switchOutCurve:
                                                          Curves.easeOut,
                                                      child: !uploading
                                                          ? const Icon(
                                                              CupertinoIcons
                                                                  .cloud_upload,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : const LoadingSpinner(
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            )
          ],
        ));
  }
}
