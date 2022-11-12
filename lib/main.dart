import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expandable_attempt/Utilities/utils.dart';
import 'package:expandable_attempt/cubits/cubit/navigation_cubit.dart';
import 'package:expandable_attempt/cubits/cubit/saved_cubit.dart';
import 'package:expandable_attempt/screens/root_screen.dart';

import 'cubits/cubit/auth_cubit.dart';
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
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Schedule test',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          // colorScheme: const ColorScheme(
          //     brightness: Brightness.light,
          //     primary: Color(0xFF040306),
          //     onPrimary: Colors.white,
          //     secondary: Color(0xFF040306),
          //     onSecondary: Color(0xFF040306),
          //     error: Color(0xFF040306),
          //     onError: Color(0xFF040306),
          //     background: Color(0xFF040306),
          //     onBackground: Color(0xFF040306),
          //     surface: Color(0xFF040306),
          //     onSurface: Color(0xFF040306)),
        ),
        home: const RootScreen(),
        /*routes: {
          '/': (context) => const RootScreen(),
          '/login': (context) => const AuthPage(),
          '/schedule': (context) => const HomeScreen(
              title: 'Schedule Home Screen', color: Colors.purpleAccent, category: ,),
          '/mySchedule': (context) => const MySchedule(
                title: 'Schedule Home Screen',
                color: Colors.purpleAccent,
              ),
        },*/
      ),
    );
  }
}
