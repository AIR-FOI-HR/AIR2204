import 'package:expandable_attempt/constants/schedule_item_category_model.dart';
import 'package:expandable_attempt/screens/root_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/schedule_item.dart';
import '../Utilities/utils.dart';
import '../cubits/cubit/auth_cubit.dart';

class AppBarButtons extends StatefulWidget {
  const AppBarButtons({super.key});

  @override
  State<AppBarButtons> createState() => _AppBarButtonsState();
}

class _AppBarButtonsState extends State<AppBarButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: MaterialButton(
            onPressed: () => {
              Navigator.of(context).pushNamed('/mySchedule').then(
                    (_) => setState(() {}),
                  )
            },
            child: const Icon(
              Icons.directions_bike,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryButton extends StatelessWidget {
  const CategoryButton(
      {super.key, required this.color, required this.onPressed});

  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: color,
      onPressed: onPressed,
      icon: const Icon(Icons.bike_scooter),
    );
  }
}

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //final user = FirebaseAuth.instance.currentUser!.email;
          return Row(
            children: [
              //Text('User: $user'),
              MaterialButton(
                onPressed: () {
                  logOut();
                },
                child: const Icon(
                  Icons.lock_open,
                  size: 20,
                ),
              ),
            ],
          );
        } else {
          return MaterialButton(
            onPressed: () {
              BlocProvider.of<AuthCubit>(context).guestLoginToggle();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RootScreen()),
              );
            },
            child: const Icon(
              Icons.login,
              size: 20,
            ),
          );
        }
      },
    );
  }

  void logOut() {
    Utils.showSnackBar('Logged Out');
    FirebaseAuth.instance.signOut();
  }
}

buildCategoryIcon(ScheduleItem scheduleItem) {
  final Color color;
  if (scheduleItem.category == ScheduleItemCategory.tech) {
    color = const Color(0xffe63e3e);
  } else if (scheduleItem.category == ScheduleItemCategory.ops) {
    color = const Color(0xff4666b2);
  } else if (scheduleItem.category == ScheduleItemCategory.lead) {
    color = const Color(0xffdbdce3);
  } else if (scheduleItem.category == ScheduleItemCategory.keynote) {
    color = Colors.pink;
  } else {
    color = const Color.fromARGB(0, 255, 255, 255);
  }
  return CircleAvatar(
    backgroundColor: color,
  );
}
