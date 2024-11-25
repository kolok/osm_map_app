import 'package:flutter/material.dart';

class AddActorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? successAction;

  const AddActorDialog({
    Key? key,
    required this.title,
    required this.message,
    this.successAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Ajouter'),
          onPressed: () {
            Navigator.of(context).pop();
            if (successAction != null) {
              successAction!();
            }
          },
        ),
      ],
    );
  }
}