import 'package:flutter/material.dart';
import 'package:gym_partner/utils/form_validators.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:gym_partner/widgets/small_circle_progress_indicator.dart';

class ChangeUserDataModal extends StatefulWidget {
  const ChangeUserDataModal({
    super.key,
    required this.title,
    required this.fieldLabel,
    required this.passwordFieldLabel,
    required this.type,
    required this.onSave,
  });

  final String title;
  final String fieldLabel;
  final String passwordFieldLabel;
  final FormFieldType type;
  final Future<void> Function(String userData, String password) onSave;

  @override
  State<ChangeUserDataModal> createState() => _ChangeUserDataModalState();
}

class _ChangeUserDataModalState extends State<ChangeUserDataModal> {
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

  void _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(
      () => _isAuthenticating = true,
    );

    await widget.onSave(
      _userDataController.text,
      _passwordController.text,
    );

    setState(
      () => _isAuthenticating = false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    var cancelButton = OutlinedButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    var saveButton = ElevatedButton(
      onPressed: _save,
      child: _isAuthenticating
          ? const SmallCircleProgressIndicator()
          : const Text("Save"),
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, keyboardSpace + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _userDataController,
                      validator: validatorForType(widget.type),
                      obscureText: widget.type == FormFieldType.password,
                      decoration:
                          InputDecoration(label: Text(widget.fieldLabel)),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          label: Text(widget.passwordFieldLabel)),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        cancelButton,
                        const SizedBox(width: 6),
                        saveButton,
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
