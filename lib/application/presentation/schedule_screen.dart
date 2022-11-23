import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/schedule_items.dart';
import '../logic/schedule_cubit.dart';
import 'detail_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ScheduleCubit>(context).readScheduleItems();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule test list'),
      ),
      body: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.scheduleItems.length,
            itemBuilder: (context, index) {
              return listBuild(state.scheduleItems[index]);
            },
          );
        },
      ),
    );
  }

  Widget listBuild(ScheduleItem scheduleItem) {
    return ExpansionTile(
      title: Text(scheduleItem.title),
      subtitle: Text(scheduleItem.time),
      children: [
        SizedBox(
          width: 40,
          child: MaterialButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(scheduleItem: scheduleItem),
                ),
              ),
            },
            child: const Icon(Icons.more_horiz, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        const Text('More'),
      ],
      //za prikaz time treba parsirati startTime i endTime da se uzme van onaj dio koji nam treba
    );
  }
}
