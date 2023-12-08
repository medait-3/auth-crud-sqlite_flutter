import 'package:flutter/material.dart';

import 'color.dart';

class AuthField extends StatefulWidget {
  // final String title;
  final String hintText;
  final Color? titleColor;
  final IconData prefixIconData;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final int? maxLines;
  const AuthField({
    required this.prefixIconData,
    // required this.title,
    required this.hintText,
    required this.controller,
    this.validator,
    this.titleColor,
    this.maxLines,
    this.textInputAction,
    this.keyboardType,
    this.isPassword = false,
    super.key,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   widget.title,
          //   style: TextStyle(
          //       fontSize: 14,
          //       color: widget.titleColor ?? const Color(0xFF78828A)),
          // ),
          // SizedBox(height: 5),
          TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            // ignore: avoid_bool_literals_in_conditional_expressions
            obscureText: widget.isPassword ? isObscure : false,
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            cursorColor:
                const Color(0xFF78828A), // Change the cursor color here

            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
                borderSide: BorderSide(
                  color: Color(0xFFF6F6F6),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
                borderSide: BorderSide(
                  color: Color(0xFFF6F6F6),
                ),
              ),
              fillColor: const Color(0xFFF6F6F6),
              filled: true,
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle:
                  const TextStyle(color: AppColors.kGrey60, fontSize: 16),
              prefixIcon: Icon(
                widget.prefixIconData,
                color: AppColors.kGrey60,
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xFF171725)),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
