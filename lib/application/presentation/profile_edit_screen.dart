import 'package:deep_conference/application/logic/user_cubit.dart';
import 'package:deep_conference/application/presentation/auth_widgets.dart';
import 'package:deep_conference/application/presentation/password_change_screen.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Utilities/utils.dart';
import '../../constants/my_icons.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key, required this.stateData});

  final UserState stateData;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController companyUrlController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().initState();
    context.read<UserCubit>().checkAuthProvider();
    emailController.text = widget.stateData.email;
    firstNameController.text = widget.stateData.firstName;
    lastNameController.text = widget.stateData.lastName;
    companyUrlController.text = widget.stateData.companyUrl;
    phoneNumberController.text = widget.stateData.phoneNumber;
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    companyUrlController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.editMyProfile,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: MyColors.color9B9A9B,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state.error != null) {
            Utils.showSnackBar(state.error?.message(context), context);
          }
          if (state.userUpdated) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: MyColors.color772DFF.withAlpha(15),
              image: const DecorationImage(
                image: AssetImage(MyIcons.editProfileBackground),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
              child: ListView(
                children: [
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldWidget(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        label: AppLocalizations.of(context)!.email,
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
                        onChanged: context.read<UserCubit>().onCompanyUrlChanged,
                        errorText: state.companyUrlError?.message(context),
                        controller: companyUrlController,
                        keyboardType: TextInputType.url,
                        label: AppLocalizations.of(context)!.companyUrlSignUpLabel,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget(
                        onChanged: context.read<UserCubit>().onPhoneNumberChanged,
                        errorText: state.phoneNumberError?.message(context),
                        inputAction: TextInputAction.done,
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        label: AppLocalizations.of(context)!.phoneNumberSignUpLabel,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: Text(
                          !state.passwordProvider
                              ? AppLocalizations.of(context)!.changePasswordNoPassword
                              : AppLocalizations.of(context)!.changePassword,
                          style: !state.passwordProvider
                              ? Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: MyColors.color9B9A9B, decoration: TextDecoration.underline)
                              : Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: MyColors.colorFB65BA, decoration: TextDecoration.underline),
                        ),
                        onTap: () => !state.passwordProvider
                            ? {}
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PasswordChangeScreen(),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthButtonWidget(
                        label: AppLocalizations.of(context)!.saveChanges,
                        onPressed: () {
                          context.read<UserCubit>().writeUserData(
                              emailController.text.trim(),
                              firstNameController.text.trim(),
                              lastNameController.text.trim(),
                              companyUrlController.text.trim(),
                              phoneNumberController.text.trim());
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
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
