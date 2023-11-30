import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool? obsecureText;
  final IconData prefixIconData;
  final Color prefixIconColor;
  final bool suffixIcon;
  const MyTextField({
    super.key,
    required this.suffixIcon,
    required this.controller,
    required this.hintText,
    this.obsecureText,
    required this.prefixIconData,
    required this.prefixIconColor,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: TextField(
        controller: widget.controller,
        obscureText: obsecureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.redAccent,
            ),
          ),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(
            widget.prefixIconData,
            color: widget.prefixIconColor,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
