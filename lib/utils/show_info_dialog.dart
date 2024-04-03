import 'package:flutter/material.dart';
import 'package:gym_partner/widgets/modals/confirmation_modal.dart';

void showCustomInfoDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (context) => ConfirmationModal(
      title: title,
      content: content,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
