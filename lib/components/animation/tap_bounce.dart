import 'package:flutter/material.dart';

class TapBounce extends StatefulWidget {
  const TapBounce(
      {super.key,
      required this.child,
      this.duration = const Duration(milliseconds: 150),
      this.scale = 0.99,
      this.onTap,
      this.curve = Curves.easeOut});
  final Widget child;
  final Duration duration;
  final double scale;
  final void Function()? onTap;
  final Curve curve;

  @override
  State<TapBounce> createState() => _TapBounceState();
}

class _TapBounceState extends State<TapBounce> {
  double _scale = 1;

  void _animateBounce() {
    setState(() {
      _scale = widget.scale;
    });
    Future.delayed(widget.duration, () {
      setState(() {
        _scale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      curve: widget.curve,
      duration: widget.duration,
      child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _animateBounce();
            Future.delayed(widget.duration, () {
              if (widget.onTap != null) {
                widget.onTap!();
              }
            });
          },
          child: widget.child),
    );
  }
}
