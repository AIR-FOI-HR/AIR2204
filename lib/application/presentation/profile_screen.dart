import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    super.initState();
    context.read<UserCubit>().getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profileScreenTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state.userData) {
            return Text(state.firstName);
          } else {
            return Text(AppLocalizations.of(context)!.noData);
          }
        },
      ),
    );
  }
}
