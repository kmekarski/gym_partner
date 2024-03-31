import 'package:flutter/material.dart';
import 'package:gym_partner/widgets/modals/confirmation_modal.dart';
import 'package:gym_partner/widgets/small_circle_progress_indicator.dart';

class SignoutConfirmationModal extends StatefulWidget {
  const SignoutConfirmationModal({
    super.key,
    required this.onSignOut,
  });

  final void Function() onSignOut;

  @override
  State<SignoutConfirmationModal> createState() =>
      _DeletePlanConfirmationModalState();
}

class _DeletePlanConfirmationModalState
    extends State<SignoutConfirmationModal> {
  bool _isSigningOut = false;
  @override
  Widget build(BuildContext context) {
    Widget cancelButton = OutlinedButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    var signOutButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: _isSigningOut
          ? const SmallCircleProgressIndicator()
          : Text(
              "Sign out",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
      onPressed: () {
        setState(() {
          _isSigningOut = true;
        });
        widget.onSignOut();
      },
    );
    return ConfirmationModal(
      title: 'Sign out',
      content: 'Do you want to sign out?',
      actions: [cancelButton, signOutButton],
    );
  }
}
