import 'package:expandable_attempt/cubits/cubit/saved_cubit.dart';
import 'package:expandable_attempt/screens/item_detail.dart';
import 'package:expandable_attempt/screens/my_schedule.dart';
import 'package:expandable_attempt/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/models/schedule_item_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedCubit(),
      child: MaterialApp(
          title: 'Schedule test',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/': (context) => const HomeScreen(
                title: 'Schedule Home Screen', color: Colors.purpleAccent),
            '/mySchedule': (context) => MySchedule(
                  title: 'Schedule Home Screen',
                  color: Colors.purpleAccent,
                )
          }),
    );
  }
}
