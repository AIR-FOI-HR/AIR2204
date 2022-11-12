import 'dart:html';
import 'package:expandable_attempt/cubits/cubit/navigation_cubit.dart';
import 'package:expandable_attempt/cubits/cubit/saved_cubit.dart';
import 'package:expandable_attempt/screens/login_screen.dart';
import 'package:expandable_attempt/screens/my_schedule.dart';
import 'package:expandable_attempt/screens/home_screen.dart';
import 'package:expandable_attempt/screens/root_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: 'Schedule test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => RootScreen(),
          '/login': (context) => LoginScreen(),
          '/schedule': (context) => const HomeScreen(title: 'Schedule Home Screen', color: Colors.purpleAccent),
          '/mySchedule': (context) => MySchedule(
                title: 'Schedule Home Screen',
                color: Colors.purpleAccent,
              ),
        },
      ),
    );
  }
}
