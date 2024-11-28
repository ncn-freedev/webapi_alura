import 'package:flutter/material.dart';

showExceptionDialog(
  BuildContext context, {
  String title = "Um problema ocorreu!",
  required String content,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            SizedBox(width: 4),
            Text(title,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        content: Text(content),
        actions: [
          TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Ok",
            style: TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ],
      );
    },
  );
}
