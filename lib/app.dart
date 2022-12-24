import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_conference/application/logic/saved_schedule_cubit.dart';
import 'package:deep_conference/domain/repositories/saved_schedule_repository.dart';
import 'package:deep_conference/domain/repositories/schedule_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:deep_conference/domain/repositories/speaker_repository.dart';
import 'application/logic/authentication_cubit.dart';
import 'application/logic/contacts_cubit.dart';
import 'application/logic/navigation_cubit.dart';
import 'application/logic/schedule_cubit.dart';
import 'application/logic/user_cubit.dart';
import 'application/presentation/root_screen.dart';
import 'constants/theme_data.dart';
import 'domain/repositories/authentication_repository.dart';
import 'domain/repositories/user_repository.dart';

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
        RepositoryProvider<SavedRepository>(
          create: (context) => SavedRepository(firestore: firestore, auth: auth),
        ),
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(googleSignIn: googleSignIn, auth: auth, firestore: firestore),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(auth: auth, firestore: firestore),
        ),
        RepositoryProvider<SpeakerRepository>(
          create: (context) => SpeakerRepository(firestore: firestore),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ScheduleCubit>(create: (context) => ScheduleCubit(context.read<ScheduleRepository>())),
          BlocProvider<SavedScheduleCubit>(
              create: (context) =>
                  SavedScheduleCubit(context.read<SavedRepository>(), context.read<ScheduleRepository>())),
          BlocProvider<NavigationCubit>(create: (context) => NavigationCubit()),
          BlocProvider<AuthenticationCubit>(
            create: (context) =>
                AuthenticationCubit(context.read<AuthenticationRepository>(), context.read<UserRepository>()),
          ),
          BlocProvider<UserCubit>(
            create: (context) => UserCubit(context.read<UserRepository>()),
          ),
          BlocProvider<ContactsCubit>(
            create: (context) => ContactsCubit(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Deep Conference App',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          theme: MyTheme.deepTheme,
          home: const RootScreen(),
        ),
      ),
    );
  }
}
