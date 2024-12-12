import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ConfirmationDialog {
  static Future<bool?> show(
      BuildContext context, {
        String? title,
        String? message,
        List<Widget>? actions,
        bool dismissible = true,
      }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: dismissible,
      builder: (BuildContext context) {
        if (Theme.of(context).platform == TargetPlatform.iOS ||
            Theme.of(context).platform == TargetPlatform.macOS) {
          return CupertinoAlertDialog(
            title: title != null ? Text(title) : null,
            content: message != null ? Text(message) : null,
            actions: actions ??
                [
                  CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Confirm"),
                  ),
                ],
          );
        } else {
          return AlertDialog(
            title: title != null ? Text(title) : null,
            content: message != null ? Text(message) : null,
            actions: actions ??
                [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Confirm"),
                  ),
                ],
          );
        }
      },
    );
  }
}
