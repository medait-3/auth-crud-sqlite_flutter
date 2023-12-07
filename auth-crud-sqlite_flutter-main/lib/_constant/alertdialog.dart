import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String yesButtonText;
  final String noButtonText;
  final VoidCallback onYes;
  final VoidCallback onNo;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.yesButtonText,
    required this.noButtonText,
    required this.onYes,
    required this.onNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: onNo,
          child: Text(
            noButtonText,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: onYes,
          child: Text(yesButtonText),
        ),
      ],
    );
  }
}
