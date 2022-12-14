import 'package:deep_conference/application/logic/authentication_cubit.dart';
import 'package:deep_conference/application/presentation/email_verification.dart';
import 'package:deep_conference/application/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({
    super.key,
  });
  @override
  State<RootScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationCubit>().initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: ((context, state) {
        if (state.userId.isNotEmpty) {
          return const EmailVerificationScreen();
        } else {
          return const LoginScreen();
        }
      }),
    );
  }
}
