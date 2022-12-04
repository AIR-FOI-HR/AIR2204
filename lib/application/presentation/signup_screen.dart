import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_conference/application/presentation/login_screen.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../Utilities/utils.dart';
import '../../constants/my_collections.dart';
import '../../constants/my_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                  AppLocalizations.of(context)!.signUp,
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
                        labelText: AppLocalizations.of(context)!.email,
                        labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.colorFB65BA),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: MyColors.color9B9A9B),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ((value) {
                        if (value != null && !EmailValidator.validate(value)) {
                          return AppLocalizations.of(context)!.enterValidEmail;
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
                        labelText: AppLocalizations.of(context)!.password,
                        labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.colorFB65BA),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: MyColors.color9B9A9B),
                        ),
                      ),
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ((value) {
                        if (value != null && value.length < 6) {
                          return AppLocalizations.of(context)!.passwordLengthErrorMsg;
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
                              text: AppLocalizations.of(context)!.iAgreeToThe,
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: <TextSpan>[
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // TODO: Implement TOS and privacy policy link
                                    },
                                  text: AppLocalizations.of(context)!.termsOfService,
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
                          AppLocalizations.of(context)!.signUp,
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
                          AppLocalizations.of(context)!.haveAnAccount,
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
                            AppLocalizations.of(context)!.signIn,
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

      //creating an array of saved items for the user
      final docSavedItems =
          FirebaseFirestore.instance.collection(MyCollections.savedItems).doc(FirebaseAuth.instance.currentUser!.uid);
      final Map<String, dynamic> savedItems = {
        "savedItems": [],
      };
      await docSavedItems.set(savedItems);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
