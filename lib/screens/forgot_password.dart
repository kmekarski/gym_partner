import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/providers/user_plans_provider.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/utils/form_validators.dart';
import 'package:gym_partner/utils/show_info_dialog.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:gym_partner/widgets/gradients/auth_gradient.dart';
import 'package:gym_partner/widgets/small_circle_progress_indicator.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ChangeUserDataModalState();
}

class _ChangeUserDataModalState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isAuthenticating = false;

  @override
  void initState() {
    setState(() {
      _emailController.clear();
    });
    super.initState();
  }

  void _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isAuthenticating = true;
    });

    final email = _emailController.text;

    if (await ref.read(userProvider.notifier).resetPassword(email)) {
      Navigator.of(context).pop();
      showCustomInfoDialog(context, 'Success',
          'Reset password link was send to $email. Click it to set a new password.');
    } else {
      setState(() {
        _isAuthenticating = false;
      });
      showCustomInfoDialog(context, 'Alert',
          'Something went wrong. Make sure you entered your email address correctly.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    var cancelButton = OutlinedButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    var confirmButtom = ElevatedButton(
      onPressed: _resetPassword,
      child: _isAuthenticating
          ? const SmallCircleProgressIndicator()
          : const Text("Reset password"),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: authGradient(context),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reset password',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 12),
              Text(
                'Enter your email to receive a password reset link.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      validator: emailValidator,
                      decoration: const InputDecoration(label: Text('Email')),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        cancelButton,
                        const SizedBox(width: 6),
                        confirmButtom,
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
