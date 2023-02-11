import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  final text,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('an error accurred'),
        content: Text(text as String),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          )
        ],
      );
    },
  );
}

Future<void> showSucessDialog(
  BuildContext context,
  String title,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          )
        ],
      );
    },
  );
}
