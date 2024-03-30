import 'package:flutter/material.dart';
import 'package:gym_partner/widgets/modals/confirmation_modal.dart';

class EndWorkoutConfirmationModal extends StatelessWidget {
  const EndWorkoutConfirmationModal({
    super.key,
    required this.onConfirm,
  });

  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    var cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    var deleteButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        onPressed: onConfirm,
        child: Text(
          "Confirm",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ));
    return ConfirmationModal(
      title: 'End workout',
      content: 'Do you want to end this workout? Your progress will be lost.',
      actions: [cancelButton, deleteButton],
    );
  }
}
