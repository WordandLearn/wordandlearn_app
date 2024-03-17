import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:word_and_learn/components/back_button.dart';
import 'package:word_and_learn/components/components.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/controllers.dart';
import 'package:word_and_learn/models/http_response.dart';

class SessionQRPage extends StatefulWidget {
  const SessionQRPage({super.key});

  @override
  State<SessionQRPage> createState() => _SessionQRPageState();
}

class _SessionQRPageState extends State<SessionQRPage> {
  final WritingController _writingController = Get.find<WritingController>();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  Future<HttpResponse> getSession(int sessionCode) async {
    HttpResponse response =
        await _writingController.getSessionFromCode(sessionCode);
    return response;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && scanData.code!.length == 5) {
        setState(() {
          isLoading = true;
        });
        getSession(int.parse(scanData.code!)).then((value) {
          if (value.isSuccess) {
            _writingController.refetch();
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "Could not get the composition. Enter the right code or tell your teacher"),
            ));
          }
        }).whenComplete(() => setState(() {
              isLoading = false;
            }));
      }
    });
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
                height: size.height * 0.75,
                child: Stack(
                  children: [
                    QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                          borderColor: Colors.white,
                          borderWidth: 5.0,
                          borderRadius: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding * 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomBackButton(
                            color: Colors.white,
                          ),
                          Text(
                            "Scan Lesson QR Code or Enter Code",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                          ),
                          const SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                    )
                  ],
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.2,
                width: double.infinity,
                margin: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Or Enter Code Provided",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      !isLoading
                          ? Pinput(
                              length: 5,
                              onCompleted: (value) {
                                setState(() {
                                  isLoading = true;
                                });

                                getSession(int.parse(value)).then((value) {
                                  if (value.isSuccess) {
                                    _writingController.refresh();
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Could not get the composition. Enter the right code or tell your teacher"),
                                    ));
                                  }
                                }).whenComplete(() => setState(() {
                                      isLoading = false;
                                    }));
                              },
                            )
                          : const LoadingSpinner(color: AppColors.primaryColor),
                      Text(
                        "You can find the code at the final page of your report, or ask your teacher for the code.",
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
