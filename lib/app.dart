import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_conference/domain/repositories/schedule_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/logic/navigation_cubit.dart';
import 'application/logic/schedule_cubit.dart';
import 'application/presentation/root_screen.dart';
import 'constants/theme_data.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ScheduleRepository>(
          create: (context) => ScheduleRepository(firestore: firestore),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ScheduleCubit>(create: (context) => ScheduleCubit(context.read<ScheduleRepository>())),
          BlocProvider<NavigationCubit>(create: (context) => NavigationCubit())
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
