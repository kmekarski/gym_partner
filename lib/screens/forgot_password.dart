import 'package:flutter/material.dart';
import 'package:gym_partner/utils/form_validators.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:gym_partner/widgets/gradients/auth_gradient.dart';
import 'package:gym_partner/widgets/small_circle_progress_indicator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ChangeUserDataModalState();
}

class _ChangeUserDataModalState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userDataController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAuthenticating = false;

  @override
  void initState() {
    setState(() {
      _userDataController.clear();
      _passwordController.clear();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    var cancelButton = OutlinedButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    var confirmButtom = ElevatedButton(
      onPressed: () {},
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
                      controller: _userDataController,
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
