import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key, this.color, this.size});
  final Color? color;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      color: color ?? Theme.of(context).primaryColor,
      size: size ?? 30,
    );
  }
}
