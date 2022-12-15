import 'package:deep_conference/application/presentation/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  void initState() {
    super.initState();
    context.read<AuthenticationCubit>().initState();
  }

  @override
  void dispose() {
    resetEmailController.dispose();
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
            Utils.showSnackBar(state.resetErrorMessage?.message(context), context);
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
            Utils.showSnackBar(AppLocalizations.of(context)!.passwordResetEmailSent, context);
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
                  AppLocalizations.of(context)!.receiveEmailPassword,
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
                  label: AppLocalizations.of(context)!.email,
                ),
                const SizedBox(height: 40),
                AuthButtonWidget(
                  label: AppLocalizations.of(context)!.resetPassword,
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
