import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:word_and_learn/components/loading_spinner.dart';

class XFileImageBuilder extends StatelessWidget {
  const XFileImageBuilder(
      {super.key, required this.xfile, this.height, this.width});
  final XFile xfile;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: xfile.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Image.memory(
              snapshot.data!,
              width: width,
              height: height,
            );
          } else {
            return const LoadingSpinner();
          }
        });
  }
}
