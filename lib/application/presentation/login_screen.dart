import 'package:deep_conference/application/presentation/password_reset.dart';
import 'package:deep_conference/application/presentation/signup_screen.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:deep_conference/constants/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Utilities/utils.dart';
import '../logic/authentication_cubit.dart';
import 'auth_widgets.dart';

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
        body: BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state.error != null) {
              Navigator.of(context).pop(true);
              Utils.showSnackBar(state.error.toString(), context);
            }
            if (state.loading == true) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state.userId.isNotEmpty) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
          child: Container(
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
                        Image.asset(MyIcons.loginLogo, height: 180),
                        const SizedBox(height: 10),
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
                  TextFieldWidget(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    label: 'Email',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    controller: passwordController,
                    inputAction: TextInputAction.done,
                    label: 'Password',
                    obscure: true,
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        AuthButtonWidget(
                          label: 'Sign In',
                          onPressed: () =>
                              context.read<AuthenticationCubit>().signIn(emailController, passwordController),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.colorFFFFFF,
                            padding: const EdgeInsets.only(right: 8, left: 8),
                          ),
                          onPressed: () => context.read<AuthenticationCubit>().googleSignIn(),
                          icon: Image.asset(MyIcons.googleIcon, height: 18),
                          label: Text(
                            'Sign in with Google',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontFamily: 'Roboto', fontWeight: FontWeight.w400, color: MyColors.color3A3A3A),
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
        ),
      );
}
