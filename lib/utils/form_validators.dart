enum FormFieldType {
  username,
  email,
  password,
}

String? Function(String? value) validatorForType(FormFieldType type) {
  switch (type) {
    case FormFieldType.username:
      return usernameValidator;
    case FormFieldType.email:
      return emailValidator;
    case FormFieldType.password:
      return passwordValidator;
  }
}

String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty || !value.contains('@')) {
    return 'Please enter a valid email address.';
  }
  return null;
}

String? usernameValidator(String? value) {
  if (value == null || value.trim().length < 4) {
    return 'Please enter at least 4 characters.';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.trim().length < 6) {
    return 'Please enter at least 6 characters.';
  }
  return null;
}

String? repeatPasswordValidator(String? value, String password) {
  if (value == null || value.trim().length < 6 || value != password) {
    return 'Passwords must match';
  }
  return null;
}
