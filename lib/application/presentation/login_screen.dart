import 'package:deep_conference/application/presentation/password_reset.dart';
import 'package:deep_conference/application/presentation/signup_screen.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:deep_conference/constants/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Utilities/utils.dart';
import '../logic/authentication_cubit.dart';
import '../widgets/auth_widgets.dart';

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
  void initState() {
    super.initState();
    context.read<AuthenticationCubit>().initState();
  }

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
            if (state.error) {
              context.read<AuthenticationCubit>().initState();
              Navigator.of(context).pop(true);
              Utils.showSnackBar(state.loginErrorMessage?.message(context), context);
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
              Navigator.of(context).pop(true);
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
                          AppLocalizations.of(context)!.signIn,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 30),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.welcome,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFieldWidget(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    label: AppLocalizations.of(context)!.email,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    controller: passwordController,
                    inputAction: TextInputAction.done,
                    label: AppLocalizations.of(context)!.password,
                    obscure: true,
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        AuthButtonWidget(
                          label: AppLocalizations.of(context)!.signIn,
                          onPressed: () => context
                              .read<AuthenticationCubit>()
                              .signIn(emailController.text.trim(), passwordController.text.trim()),
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
                            AppLocalizations.of(context)!.signInWithGoogle,
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
                          AppLocalizations.of(context)!.forgotPassword,
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
                          AppLocalizations.of(context)!.signUp,
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
