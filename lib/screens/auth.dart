import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:gym_partner/widgets/small_circle_progress_indicator.dart';

final _firebaseAuth = FirebaseAuth.instance;

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

    final enteredEmail = _emailController.text;
    final enteredUsername = _usernameController.text;
    final enteredPassword = _passwordController.text;

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isSignIn) {
        final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
      } else {
        final userCredentials =
            await _firebaseAuth.createUserWithEmailAndPassword(
                email: enteredEmail, password: enteredPassword);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set(
          {
            'username': enteredUsername,
            'email': enteredEmail,
          },
        );
      }
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message ?? 'Authentication failed.'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var formFieldPadding = const EdgeInsets.symmetric(vertical: 4);

    var formButtons = Column(
      children: [
        WideButton(
          onPressed: _submit,
          text: _isAuthenticating
              ? null
              : _isSignIn
                  ? 'Sign in'
                  : 'Sign up',
          label:
              _isAuthenticating ? const SmallCircleProgressIndicator() : null,
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
    var emailField = Padding(
      padding: formFieldPadding,
      child: TextFormField(
        controller: _emailController,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        decoration: decoration('Email'),
        validator: (value) {
          if (value == null || value.trim().isEmpty || !value.contains('@')) {
            return 'Please enter a valid email address.';
          }
          return null;
        },
      ),
    );
    var usernameField = Padding(
      padding: formFieldPadding,
      child: TextFormField(
        controller: _usernameController,
        enableSuggestions: false,
        decoration: decoration('Username'),
        validator: (value) {
          if (value == null || value.trim().length < 4) {
            return 'Please enter at least 4 characters.';
          }
          return null;
        },
      ),
    );
    var passwordField = Padding(
      padding: formFieldPadding,
      child: TextFormField(
        controller: _passwordController,
        obscureText: true,
        decoration: decoration('Password'),
        validator: (value) {
          if (value == null || value.trim().length < 6) {
            return 'Please enter at least 6 characters.';
          }
          return null;
        },
      ),
    );
    var repeatPasswordField = Padding(
      padding: formFieldPadding,
      child: TextFormField(
        controller: _repeatPasswordController,
        obscureText: true,
        decoration: decoration('Repeat password'),
        validator: (value) {
          if (value == null ||
              value.trim().length < 6 ||
              value != _passwordController.text) {
            return 'Passwords must match';
          }
          return null;
        },
      ),
    );
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isSignIn ? 'Hey there' : 'Create your account',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isSignIn
                            ? 'Welcome back. Use your email and password to Sign in.'
                            : 'Enter your credentials and Sign up to start your fitness journey!',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  emailField,
                  if (!_isSignIn) usernameField,
                  passwordField,
                  if (!_isSignIn) repeatPasswordField,
                  const SizedBox(height: 16),
                  formButtons,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration decoration(String text) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      filled: true,
      fillColor: Theme.of(context).colorScheme.primaryContainer,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.5), width: 2.0),
        borderRadius: BorderRadius.circular(24),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      label: Text(text),
    );
  }
}
