import 'dart:html';

import 'package:expandable_attempt/screens/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expandable_attempt/Utilities/utils.dart';
import 'package:expandable_attempt/cubits/cubit/navigation_cubit.dart';
import 'package:expandable_attempt/cubits/cubit/saved_cubit.dart';
import 'package:expandable_attempt/screens/home_screen.dart';
import 'package:expandable_attempt/screens/login_screen.dart';
import 'package:expandable_attempt/screens/my_schedule.dart';
import 'package:expandable_attempt/screens/root_screen.dart';

import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

/* void main() {
  runApp(const MyApp());
} */

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SavedCubit>(
          create: (context) => SavedCubit(),
        ),
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Schedule test',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        routes: {
          '/': (context) => const RootScreen(
                guestLogin: false,
              ),
          '/login': (context) => const AuthPage(),
          '/schedule': (context) => const HomeScreen(
              title: 'Schedule Home Screen', color: Colors.purpleAccent),
          '/mySchedule': (context) => const MySchedule(
                title: 'Schedule Home Screen',
                color: Colors.purpleAccent,
              ),
        },
      ),
    );
  }
}
