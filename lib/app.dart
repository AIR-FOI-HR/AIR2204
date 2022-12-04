import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_conference/application/logic/saved_schedule_cubit.dart';
import 'package:deep_conference/domain/repositories/saved_schedule_repository.dart';
import 'package:deep_conference/domain/repositories/schedule_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Utilities/utils.dart';
import 'application/logic/navigation_cubit.dart';
import 'application/logic/schedule_cubit.dart';
import 'application/presentation/root_screen.dart';
import 'constants/theme_data.dart';
import 'main.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ScheduleRepository>(
          create: (context) => ScheduleRepository(firestore: firestore),
        ),
        RepositoryProvider<SavedRepository>(
          create: (context) => SavedRepository(firestore: firestore),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ScheduleCubit>(create: (context) => ScheduleCubit(context.read<ScheduleRepository>())),
          BlocProvider<SavedScheduleCubit>(
              create: (context) =>
                  SavedScheduleCubit(context.read<SavedRepository>(), context.read<ScheduleRepository>())),
          BlocProvider<NavigationCubit>(create: (context) => NavigationCubit())
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          scaffoldMessengerKey: Utils.messengerKey,
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
