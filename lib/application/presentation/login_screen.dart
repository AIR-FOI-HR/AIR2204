import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_conference/application/presentation/password_reset.dart';
import 'package:deep_conference/application/presentation/signup_screen.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:deep_conference/constants/my_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../Utilities/utils.dart';
import '../../constants/my_collections.dart';
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
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.color772DFF,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 60)),
                        onPressed: signIn,
                        child: Text(
                          "Sign In",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.colorFFFFFF,
                          padding: const EdgeInsets.only(right: 10),
                        ),
                        onPressed: signInGoogle,
                        icon: Image.asset('images/icons/btn_google_light_normal_ios-svg.png', height: 40),
                        label: Text(
                          'Sign in with Google',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontFamily: 'Roboto', fontWeight: FontWeight.w400, color: MyColors.color3A3A3A),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
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

  void signInGoogle() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final googleSignIn = GoogleSignIn(scopes: ['email']);

    try {
      final googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return;
      }
      final googleSignInAuthentication = await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      if (authResult.additionalUserInfo!.isNewUser) {
        if (authResult.user != null) {
          final docRef = FirebaseFirestore.instance
              .collection(MyCollections.savedItems)
              .doc(FirebaseAuth.instance.currentUser!.uid);

          final Map<String, dynamic> savedItems = {
            "savedItems": [],
          };
          await docRef.set(savedItems);
        }
      }
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      String content = "An unknown error has occured";
      switch (e.code) {
        case 'account-exists-with-different-credential':
          content = 'This account exists with a different sign in provider';
          break;
        case 'invalid-credential':
          content = 'Unknown error has occurred';
          break;
        case 'operation-not-allowed':
          content = 'This operation is not allowed';
          break;
        case 'user-disabled':
          content = 'The user you tried to log into was disabled';
          break;
        case 'user-not-found':
          content = 'The user you tried to log into was not found';
          break;
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Log in with google failed'),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
  }

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
