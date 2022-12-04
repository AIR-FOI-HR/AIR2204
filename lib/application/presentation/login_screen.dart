import 'package:deep_conference/application/presentation/password_reset.dart';
import 'package:deep_conference/application/presentation/signup_screen.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:deep_conference/constants/my_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Utilities/utils.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(MyIcons.authBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
            child: ListView(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Column(
                    children: [
                      Image.asset(MyIcons.categoryIcons['all']!),
                      Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 30),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Welcome!',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  cursorHeight: 24,
                  cursorColor: MyColors.colorFFFFFF,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.colorFB65BA),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: MyColors.color9B9A9B),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  cursorHeight: 24,
                  cursorColor: MyColors.colorFFFFFF,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.colorFB65BA),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: MyColors.color9B9A9B),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.color772DFF,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 60)),
                    onPressed: signIn,
                    child: Text(
                      "Sign In",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PasswordReset(),
                        )),
                      },
                      child: Text(
                        'Forgot your password?',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        ),
                      },
                      child: Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.colorFB65BA),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
