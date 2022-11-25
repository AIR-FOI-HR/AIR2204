import 'package:deep_conference/application/logic/navigation_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'application/logic/schedule_cubit.dart';
import 'application/presentation/root_screen.dart';
import 'data/firebase_options.dart';

//na ovaj način se aplikacija povezuje na firebase
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScheduleCubit>(create: (context) => ScheduleCubit()),
        BlocProvider<NavigationCubit>(create: (context) => NavigationCubit())
      ],
      child: MaterialApp(
        title: 'Deep Conference App',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: Colors.deepPurple,
          colorScheme: const ColorScheme(
              brightness: Brightness.dark,
              primary: Color(0xFF772DFF), //primary highlight color
              onPrimary: Colors.white, //text color
              secondary: Color(0xff3a3a3a), //secondary background color (bottom nav)
              onSecondary: Color(0xffD9D9D9), //highlighted element on secondary
              shadow: Color(0xff9b9a9b), //unselected element on secondary, muted elements
              error: Color(0xFF040306),
              onError: Color(0xFF040306),
              background: Color(0xFF040306), //background color
              onBackground: Color(0xFF040306),
              surface: Color(0xFF040306),
              onSurface: Color(0xFF040306)),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontSize: 24, color: Colors.white), //appbar title text
            titleMedium: TextStyle(fontSize: 14, color: Colors.white), //medium title text (date filtration buttons)
            labelMedium: TextStyle(
              fontSize: 14,
              color: Color(0xff9b9a9b),
            ), //medium gray text
            bodyLarge: TextStyle(
                fontSize: 16, color: Colors.white, overflow: TextOverflow.ellipsis), //big body text with overflow
          ),
        ),
        home: const RootScreen(),
      ),
    );
  }
}
