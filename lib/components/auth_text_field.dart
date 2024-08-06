import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.hintText,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.fillColor,
    this.focusedBorderColor,
  });
  final String hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Color? fillColor;
  final Color? focusedBorderColor;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool isHidden;

  @override
  void initState() {
    isHidden = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: isHidden,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete,
      decoration: InputDecoration(
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: defaultPadding * 3, vertical: defaultPadding * 2),
          hintStyle: const TextStyle(fontWeight: FontWeight.w600),
          filled: true,
          fillColor: widget.fillColor ?? Colors.white,
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                  child: Icon(
                    isHidden
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: Colors.grey,
                  ),
                )
              : null,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.focusedBorderColor ?? AppColors.buttonColor,
                  width: 1.5),
              borderRadius: BorderRadius.circular(10))),
    );
  }
}
