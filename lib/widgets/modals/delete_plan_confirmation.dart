import 'package:flutter/material.dart';
import 'package:gym_partner/widgets/modals/confirmation_modal.dart';

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
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    var deleteButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: _isDeleting
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
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