import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_partner/screens/forgot_password.dart';
import 'package:gym_partner/utils/form_validators.dart';
import 'package:gym_partner/utils/scaffold_messeger_utils.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:gym_partner/widgets/gradients/background_gradient.dart';
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
      showSnackBar(context, err.message ?? 'Authentication failed.');
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const fieldsTextStyle = TextStyle(fontSize: 18);
    const formFieldPadding = EdgeInsets.symmetric(vertical: 4);
    final brightness = MediaQuery.of(context).platformBrightness;
    final textButtonsColor = brightness == Brightness.light
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.primaryContainer;

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
        const SizedBox(height: 6),
        TextButton(
          onPressed: () => setState(
            () {
              _isSignIn = !_isSignIn;
            },
          ),
          child: Text(
            _isSignIn ? 'Create an account' : 'I already have an account',
            style: TextStyle(color: textButtonsColor),
          ),
        ),
      ],
    );
    var emailField = Padding(
      padding: formFieldPadding,
      child: TextFormField(
          controller: _emailController,
          style: fieldsTextStyle,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          decoration: const InputDecoration(label: Text('Email')),
          validator: emailValidator),
    );
    var usernameField = Padding(
      padding: formFieldPadding,
      child: TextFormField(
          controller: _usernameController,
          style: fieldsTextStyle,
          enableSuggestions: false,
          decoration: const InputDecoration(label: Text('Username')),
          validator: usernameValidator),
    );
    var passwordField = Padding(
      padding: formFieldPadding,
      child: TextFormField(
        controller: _passwordController,
        style: fieldsTextStyle,
        obscureText: true,
        decoration: const InputDecoration(label: Text('Password')),
        validator: passwordValidator,
      ),
    );
    var repeatPasswordField = Padding(
      padding: formFieldPadding,
      child: TextFormField(
        controller: _repeatPasswordController,
        obscureText: true,
        style: fieldsTextStyle,
        decoration: const InputDecoration(label: Text('Repeat password')),
        validator: (value) =>
            repeatPasswordValidator(value, _passwordController.text),
      ),
    );
    var bigHeaderText = Text(
      _isSignIn ? 'Hey there' : 'Create your account',
      style: Theme.of(context).textTheme.displaySmall,
    );
    var smallHeaderText = Text(
      _isSignIn
          ? 'Welcome back! Use your email and password to Sign in.'
          : 'Enter your credentials and Sign up to start your fitness journey!',
      style: Theme.of(context).textTheme.bodyLarge,
    );
    var forgotPasswordButton = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                'Forgot password?',
                style: TextStyle(
                    color: textButtonsColor, fontWeight: FontWeight.w600),
              ),
            )),
      ],
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: authBackgroundGradient(context,
              diagonalOrientation: GradientDialonalOrientation.right),
        ),
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
                      bigHeaderText,
                      const SizedBox(height: 12),
                      smallHeaderText,
                    ],
                  ),
                  const SizedBox(height: 24),
                  emailField,
                  if (!_isSignIn) usernameField,
                  passwordField,
                  if (_isSignIn) forgotPasswordButton,
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
}
