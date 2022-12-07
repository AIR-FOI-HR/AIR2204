import 'package:deep_conference/application/logic/authentication_cubit.dart';
import 'package:deep_conference/application/presentation/auth_widgets.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Utilities/utils.dart';
import '../../constants/my_icons.dart';

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
            //Navigator.of(context).pop(true);
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
                      TextFormFieldWidget(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        label: 'Email',
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
                      TextFormFieldWidget(
                        controller: passwordController,
                        obscure: true,
                        label: 'Password',
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
                      TextFormFieldWidget(
                        inputAction: TextInputAction.done,
                        obscure: true,
                        label: 'Repeat password',
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!.copyWith(color: MyColors.colorFB65BA),
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
                      AuthButtonWidget(
                        label: 'Sign Up',
                        onPressed: () =>
                            context.read<AuthenticationCubit>().signUp(formKey, emailController, passwordController),
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
                              Navigator.of(context).pop(),
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
      ),
    );
  }
}
