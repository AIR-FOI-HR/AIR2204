import 'package:deep_conference/application/presentation/profile_edit_screen.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Utilities/utils.dart';
import '../../constants/my_icons.dart';
import '../logic/authentication_cubit.dart';
import '../logic/user_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    context.read<UserCubit>().getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Image(
          image: AssetImage(MyIcons.appBarBackground),
          fit: BoxFit.cover,
        ),
        title: Text(
          AppLocalizations.of(context)!.profileScreenTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: InkWell(
            highlightColor: MyColors.color040306,
            splashColor: MyColors.color3A3A3A,
            radius: 50,
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              showModalBottomSheet<void>(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 150,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 20),
                          BlocBuilder<UserCubit, UserState>(
                            builder: (context, userState) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(10),
                                highlightColor: MyColors.color9B9A9B.withAlpha(82),
                                splashColor: MyColors.colorFFFFFF,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileEditScreen(
                                        stateData: userState,
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      const Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: MyColors.color000000,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        AppLocalizations.of(context)!.profileEditLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(color: MyColors.color000000),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            highlightColor: MyColors.color9B9A9B.withAlpha(82),
                            splashColor: MyColors.colorFFFFFF,
                            onTap: () {
                              Navigator.of(context).pop();
                              context.read<AuthenticationCubit>().signOut();
                            },
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  const Icon(
                                    Icons.logout,
                                    size: 20,
                                    color: MyColors.color000000,
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    AppLocalizations.of(context)!.profileSignOutLabel,
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.color000000),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: const SizedBox(width: 50, child: Icon(Icons.more_vert, size: 25)),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              highlightColor: MyColors.color040306,
              splashColor: MyColors.color3A3A3A,
              radius: 50,
              borderRadius: BorderRadius.circular(50),
              onTap: () => {
                // implement notification screen
              },
              child: const SizedBox(width: 50, child: Icon(Icons.notifications, size: 25)),
            ),
          ),
        ],
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state.error != null) {
            Utils.showSnackBar(state.error?.message(context), context);
          }
          if (state.userUpdated) {
            Utils.showSnackBar(AppLocalizations.of(context)!.userUpdateSuccessful, context);
          }
        },
        builder: (context, state) {
          if (state.userData) {
            return Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 27),
                      Container(
                        padding: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 15),
                        width: 300,
                        decoration: BoxDecoration(
                          color: MyColors.color772DFF.withAlpha(15),
                          borderRadius: BorderRadius.circular(15),
                          image: const DecorationImage(
                            image: AssetImage(MyIcons.profileScreenQrBackground),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'images/qr_placeholder.jpg',
                                height: 180,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text("${state.firstName} ${state.lastName}",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: MyColors.color772DFF, fontSize: 20, overflow: TextOverflow.visible)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                      Text(AppLocalizations.of(context)!.profileEmailLabel,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.color772DFF)),
                      const SizedBox(height: 5),
                      Text(state.email,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(overflow: TextOverflow.visible)),
                      const SizedBox(height: 35),
                      Text(AppLocalizations.of(context)!.profilePhoneNumberLabel,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.color772DFF)),
                      const SizedBox(height: 5),
                      Text(state.phoneNumber,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(overflow: TextOverflow.visible)),
                      const SizedBox(height: 35),
                      Text(AppLocalizations.of(context)!.profileCompanyUrlLabel,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.color772DFF)),
                      const SizedBox(height: 5),
                      Text(state.companyUrl,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(overflow: TextOverflow.visible)),
                      const SizedBox(height: 35),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.color772DFF,
                          padding: const EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
                        ),
                        onPressed: () {},
                        icon: Image.asset(
                          MyIcons.qrIcon,
                          height: 24,
                        ),
                        label: Text(AppLocalizations.of(context)!.addNewContact,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
