import 'package:flutter/material.dart';
import 'package:gym_partner/utils/form_validators.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';

class ChangeUserDataModal extends StatefulWidget {
  const ChangeUserDataModal(
      {super.key,
      required this.title,
      required this.fieldLabel,
      required this.passwordFieldLabel,
      required this.type,
      required this.onSave});

  final String title;
  final String fieldLabel;
  final String passwordFieldLabel;
  final FormFieldType type;

  final void Function() onSave;

  @override
  State<ChangeUserDataModal> createState() => _ChangeUserDataModalState();
}

class _ChangeUserDataModalState extends State<ChangeUserDataModal> {
  final _formKey = GlobalKey<FormState>();
  final _userDataController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    setState(() {
      _userDataController.clear();
      _passwordController.clear();
    });
    super.initState();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    widget.onSave;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    var cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    var saveButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        onPressed: _save,
        child: Text(
          "Save",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ));

    return SizedBox(
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
                          SizedBox(width: 6),
                          saveButton
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
