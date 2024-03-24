import 'package:flutter/material.dart';
import 'package:gym_partner/models/exercise.dart';
import 'package:gym_partner/widgets/modals/confirmation_modal.dart';

class ExerciseInfoModal extends StatelessWidget {
  const ExerciseInfoModal({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final okButton = ElevatedButton(
        onPressed: () => Navigator.of(context).pop(), child: const Text('OK'));
    return ConfirmationModal(
        title: exercise.name,
        content: exercise.description,
        actions: [okButton]);
  }
}
