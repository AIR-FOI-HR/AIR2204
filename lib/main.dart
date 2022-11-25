import 'package:deep_conference/application/logic/navigation_cubit.dart';
import 'package:deep_conference/constants/theme_data.dart';
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
        debugShowCheckedModeBanner: false,
        title: 'Deep Conference App',
        theme: MyTheme.deepTheme,
        home: const RootScreen(),
      ),
    );
  }
}
