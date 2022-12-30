import 'package:deep_conference/application/logic/user_cubit.dart';
import 'package:deep_conference/application/widgets/appbar_items.dart';
import 'package:deep_conference/application/widgets/auth_widgets.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Utilities/utils.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({
    super.key,
  });

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().initState();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    repeatPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.changePassword,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: backArrow(context),
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state.loading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state.error != null) {
            context.read<UserCubit>().initState();
            Navigator.of(context).pop();
            Utils.showSnackBar(text: state.error?.message(context), context: context, warning: true);
          }
          if (state.userUpdated) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: MyColors.color772DFF.withAlpha(15),
              image: const DecorationImage(
                image: AssetImage("images/backgrounds/edit_profile_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 40, right: 40, bottom: 40),
              child: ListView(
                children: [
                  TextFieldWidget(
                    controller: oldPasswordController,
                    obscure: true,
                    label: AppLocalizations.of(context)!.currentPassword,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    onChanged: context.read<UserCubit>().onPasswordChanged,
                    errorText: state.passwordError?.message(context),
                    controller: newPasswordController,
                    obscure: true,
                    label: AppLocalizations.of(context)!.newPassword,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    onChanged: context.read<UserCubit>().onRepeatPasswordChanged,
                    errorText: state.repeatPasswordError?.message(context),
                    controller: repeatPasswordController,
                    obscure: true,
                    label: AppLocalizations.of(context)!.repeatNewPassword,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  AuthButtonWidget(
                    label: AppLocalizations.of(context)!.changePassword,
                    onPressed: () {
                      context.read<UserCubit>().changeUserPassword(oldPasswordController.text.trim(),
                          newPasswordController.text.trim(), repeatPasswordController.text.trim());
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: TextButton(
                        child: Text(
                          AppLocalizations.of(context)!.cancelButton,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: MyColors.colorFFFFFF, decoration: TextDecoration.underline),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
