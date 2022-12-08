import 'package:deep_conference/application/presentation/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Utilities/utils.dart';
import '../../constants/my_icons.dart';
import '../logic/authentication_cubit.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final resetEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
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
          if (state.resetEmail == true) {
            Navigator.of(context).pop(true);
            Utils.showSnackBar('Password Reset Email Sent', context);
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
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40, top: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Receive an email to reset your password.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(overflow: TextOverflow.visible),
                ),
                const SizedBox(height: 40),
                TextFieldWidget(
                  inputAction: TextInputAction.done,
                  onChanged: context.read<AuthenticationCubit>().onEmailChanged,
                  errorText: state.emailError?.message(context),
                  controller: resetEmailController,
                  keyboardType: TextInputType.emailAddress,
                  label: 'Email',
                ),
                const SizedBox(height: 40),
                AuthButtonWidget(
                  label: 'Reset Password',
                  onPressed: () => context.read<AuthenticationCubit>().resetPassword(resetEmailController.text.trim()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
