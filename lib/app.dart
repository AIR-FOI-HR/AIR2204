import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_conference/domain/repositories/authentication_repository.dart';
import 'package:deep_conference/domain/repositories/schedule_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'application/logic/authentication_cubit.dart';
import 'application/logic/navigation_cubit.dart';
import 'application/logic/schedule_cubit.dart';
import 'application/presentation/root_screen.dart';
import 'constants/theme_data.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final firestore = FirebaseFirestore.instance;
  final googleSignIn = GoogleSignIn(scopes: ['email']);
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ScheduleRepository>(
          create: (context) => ScheduleRepository(firestore: firestore),
        ),
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(googleSignIn: googleSignIn, auth: auth, firestore: firestore),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ScheduleCubit>(create: (context) => ScheduleCubit(context.read<ScheduleRepository>())),
          BlocProvider<NavigationCubit>(create: (context) => NavigationCubit()),
          BlocProvider<AuthenticationCubit>(
              create: (context) => AuthenticationCubit(context.read<AuthenticationRepository>()))
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Deep Conference App',
          theme: MyTheme.deepTheme,
          home: const RootScreen(),
        ),
      ),
    );
  }
}
