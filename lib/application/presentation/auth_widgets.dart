// import 'package:deep_conference/main.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../../Utilities/utils.dart';
// import '../../app.dart';

// class SignInButton extends StatelessWidget {
//   const SignInButton(
//       {super.key, required this.context, required this.emailController, required this.passwordController});

//   final BuildContext context;
//   final TextEditingController emailController;
//   final TextEditingController passwordController;

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: signIn,
//       // icon: const Icon(Icons.lock_open),
//       child: const Text(
//         "Sign in",
//         style: TextStyle(fontSize: 24),
//       ),
//     );
//   }

//   Future signIn() async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//     try {
//       await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
//     } on FirebaseAuthException catch (e) {
//       Utils.showSnackBar(e.message);
//     }
//     // NavigatorKe(context, MaterialPageRoute(builder: ((context) => const RootScreen())));
//     navigatorKey.currentState!.popUntil((route) => route.isFirst);
//   }
// }
