import 'package:deep_conference/application/logic/authentication_cubit.dart';
import 'package:deep_conference/application/widgets/auth_widgets.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final companyUrlController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AuthenticationCubit>().initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    companyUrlController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state.error) {
            context.read<AuthenticationCubit>().initState();
            Navigator.of(context).pop(true);
            Utils.showSnackBar(state.signupErrorMessage?.message(context), context);
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
        builder: (context, state) => Container(
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
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.fieldsRequiredSignUpLabel,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 11, color: MyColors.color9B9A9B),
                ),
                Column(
                  children: [
                    TextFieldWidget(
                      onChanged: context.read<AuthenticationCubit>().onEmailChanged,
                      errorText: state.emailError?.message(context),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      label: "${AppLocalizations.of(context)!.email} *",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                      onChanged: context.read<AuthenticationCubit>().onPasswordChanged,
                      errorText: state.passwordError?.message(context),
                      controller: passwordController,
                      obscure: true,
                      label: "${AppLocalizations.of(context)!.password} *",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                      onChanged: context.read<AuthenticationCubit>().onRepeatPasswordChanged,
                      errorText: state.repeatPasswordError?.message(context),
                      controller: repeatPasswordController,
                      obscure: true,
                      label: "${AppLocalizations.of(context)!.repeatPassword} *",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                      controller: firstNameController,
                      label: AppLocalizations.of(context)!.firstNameSignUpLabel,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                      controller: lastNameController,
                      label: AppLocalizations.of(context)!.lastNameSignUpLabel,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                      onChanged: context.read<AuthenticationCubit>().onCompanyUrlChanged,
                      errorText: state.companyUrlError?.message(context),
                      controller: companyUrlController,
                      keyboardType: TextInputType.url,
                      label: AppLocalizations.of(context)!.companyUrlSignUpLabel,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                      onChanged: context.read<AuthenticationCubit>().onPhoneNumberChanged,
                      errorText: state.phoneNumberError?.message(context),
                      inputAction: TextInputAction.done,
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      label: AppLocalizations.of(context)!.phoneNumberSignUpLabel,
                    ),
                    const SizedBox(
                      height: 10,
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
                          value: state.isChecked,
                          onChanged: (newValue) => context.read<AuthenticationCubit>().isChecked(newValue),
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
                    AuthButtonWidget(
                      label: AppLocalizations.of(context)!.signUp,
                      onPressed: () {
                        context.read<AuthenticationCubit>().signUp(
                            repeatPasswordController.text.trim(),
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            firstNameController.text.trim(),
                            lastNameController.text.trim(),
                            companyUrlController.text.trim(),
                            phoneNumberController.text.trim());
                      },
                    ),
                    const SizedBox(
                      height: 40,
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
                            Navigator.of(context).pop(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
