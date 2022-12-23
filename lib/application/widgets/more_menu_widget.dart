import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/my_colors.dart';
import '../logic/authentication_cubit.dart';
import '../logic/user_cubit.dart';
import '../presentation/profile_edit_screen.dart';

class MoreMenuWidget extends StatefulWidget {
  const MoreMenuWidget({super.key});

  @override
  State<MoreMenuWidget> createState() => _MoreMenuWidgetState();
}

class _MoreMenuWidgetState extends State<MoreMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, userState) {
                        return moreMenuItem(
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
                          label: AppLocalizations.of(context)!.profileEditLabel,
                          icon: Icons.edit,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    moreMenuItem(
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<AuthenticationCubit>().signOut();
                      },
                      label: AppLocalizations.of(context)!.profileSignOutLabel,
                      icon: Icons.logout,
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const SizedBox(width: 50, child: Icon(Icons.more_vert, size: 25)),
      ),
    );
  }

  Widget moreMenuItem({required VoidCallback onTap, required String label, required IconData icon}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      highlightColor: MyColors.color9B9A9B.withAlpha(82),
      splashColor: MyColors.colorFFFFFF,
      onTap: onTap,
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(
              icon,
              size: 20,
              color: MyColors.color000000,
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.color000000),
            ),
          ],
        ),
      ),
    );
  }
}
