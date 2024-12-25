import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface, // Lightest color for background
      title: Text(
        title,
        style:  Theme.of(context).textTheme.headlineSmall,
      ),
      contentTextStyle: Theme.of(context).textTheme.bodySmall,
      content: content,
      actions: actions,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Customize border radius
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actionsAlignment: MainAxisAlignment.spaceEvenly, // Customize alignment
    );
  }
}