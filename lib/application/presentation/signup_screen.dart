import 'package:deep_conference/application/presentation/login_screen.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../Utilities/utils.dart';
import '../../constants/my_icons.dart';
import '../../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isChecked = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 30),
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ((value) {
                        if (value != null && !EmailValidator.validate(value)) {
                          return 'Enter a valid e-mail!';
                        } else {
                          return null;
                        }
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ((value) {
                        if (value != null && value.length < 6) {
                          return 'Password must be at least 6 characters long.';
                        } else {
                          return null;
                        }
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      cursorHeight: 24,
                      cursorColor: MyColors.colorFFFFFF,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Repeat password',
                        labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.colorFB65BA),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: MyColors.color9B9A9B),
                        ),
                      ),
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ((value) {
                        if (value != passwordController.text) {
                          return 'Passwords must match';
                        } else {
                          return null;
                        }
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: MyColors.colorFFFFFF,
                          activeColor: MyColors.colorFB65BA,
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(width: 1.5, color: MyColors.color9B9A9B),
                          ),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.visible,
                            text: TextSpan(
                              text: 'I agree to the ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: <TextSpan>[
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // TODO: Implement TOS and privacy policy link
                                    },
                                  text: "Terms of services and Privacy Policy",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: MyColors.colorFB65BA),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.color772DFF,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 60)),
                        onPressed: signUp,
                        child: Text(
                          "Sign Up",
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
                        Text(
                          'Have an account?',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ))
                          },
                          child: Text(
                            'Sign In',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.colorFB65BA),
                          ),
                        ),
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

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    // TODO: Validate TOS checkbox

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
