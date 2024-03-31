import 'package:flutter/material.dart';
import 'package:gym_partner/widgets/modals/confirmation_modal.dart';
import 'package:gym_partner/widgets/small_circle_progress_indicator.dart';

class DeletePlanConfirmationModal extends StatefulWidget {
  const DeletePlanConfirmationModal({
    super.key,
    required this.onDelete,
  });

  final void Function() onDelete;

  @override
  State<DeletePlanConfirmationModal> createState() =>
      _DeletePlanConfirmationModalState();
}

class _DeletePlanConfirmationModalState
    extends State<DeletePlanConfirmationModal> {
  bool _isDeleting = false;
  @override
  Widget build(BuildContext context) {
    Widget cancelButton = OutlinedButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    var deleteButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: _isDeleting
          ? const SmallCircleProgressIndicator()
          : Text(
              "Delete",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
      onPressed: () {
        setState(() {
          _isDeleting = true;
        });
        widget.onDelete();
      },
    );
    return ConfirmationModal(
      title: 'Delete plan',
      content: 'Do you want to delete this workout plan? This is irreversible.',
      actions: [cancelButton, deleteButton],
    );
  }
}
