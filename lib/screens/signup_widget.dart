import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Utilities/utils.dart';
import '../data/models/users.dart';
import '../main.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);
  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final companyUrlController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Sign up'),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Email"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
              ),
              const SizedBox(
                height: 4,
              ),
              TextFormField(
                controller: passwordController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Enter at least 6 characters'
                    : null,
              ),
              TextFormField(
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: "Repeat password"),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != passwordController.text) {
                    return 'Passwords must match';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: firstNameController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              TextFormField(
                controller: lastNameController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Last Name"),
              ),
              TextFormField(
                controller: phoneNumberController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Phone Number"),
              ),
              TextFormField(
                controller: companyUrlController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Company Url"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: signUp,
                icon: const Icon(Icons.lock_open),
                label: const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  text: "Already have an account? ",
                  children: [
                    TextSpan(
                      text: "Log in",
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      //putting user info into a firestore
      final user = AppUser(
        email: emailController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phoneNumber: phoneNumberController.text,
        companyUrl: companyUrlController.text,
      );
      final json = user.toJson();
      final docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      await docUser.set(json);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
