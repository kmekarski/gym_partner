import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isSignIn = true;
  var _isAuthenticating = false;

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var formButtons = Column(
      children: [
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Text(_isSignIn ? 'Sign in' : 'Sign up'),
        ),
        TextButton(
          onPressed: () => setState(
            () {
              _isSignIn = !_isSignIn;
            },
          ),
          child: Text(
              _isSignIn ? 'Create an account' : 'I already have an account'),
        ),
      ],
    );
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: const InputDecoration(
                        label: Text('Email'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    if (!_isSignIn)
                      TextFormField(
                        controller: _usernameController,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          label: Text('Username'),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 4) {
                            return 'Please enter at least 4 characters.';
                          }
                          return null;
                        },
                      ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        label: Text('Password'),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return 'Please enter at least 6 characters.';
                        }
                        return null;
                      },
                    ),
                    if (!_isSignIn)
                      TextFormField(
                        controller: _repeatPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          label: Text('Repeat password'),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().length < 6 ||
                              value != _passwordController.text) {
                            return 'Passwords must match';
                          }
                          return null;
                        },
                      ),
                    const SizedBox(height: 16),
                    if (_isAuthenticating)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    if (!_isAuthenticating) formButtons,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
