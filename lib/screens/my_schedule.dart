import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/cubit/saved_cubit.dart';
import '../data/models/schedule_item_model.dart';
import 'item_detail.dart';

class MySchedule extends StatefulWidget {
  MySchedule({
    super.key,
    required this.title,
    required this.color,
  });

  final String title;
  final MaterialAccentColor color;

  @override
  State<MySchedule> createState() => _MyScheduleState();
}

class _MyScheduleState extends State<MySchedule> {
  List<Schedule> savedItems = [];

  @override
  Widget build(BuildContext context) {
    savedItems = BlocProvider.of<SavedCubit>(context).state.savedItems;

    return BlocListener<SavedCubit, SavedState>(
      listener: (context, state) {
        savedItems = state.savedItems;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Personal Schedule'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: savedItems.length,
          itemBuilder: (context, index) {
            return _buildList(index);
          },
        ),
      ),
    );
  }

  Widget _buildList(index) {
    return ExpansionTile(
      title: Text(savedItems[index].time),
      subtitle: Text(savedItems[index].title),
      children: [
        SizedBox(
          width: 40,
          child: MaterialButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetail(
                      title: 'Schedule Item Details',
                      color: Colors.pinkAccent,
                      scheduleItem: savedItems[index]),
                ),
              ),
            },
            child: const Icon(Icons.more_horiz, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        Text('More'),
        SizedBox(
          width: 40,
          child: MaterialButton(
            onPressed: () {
              setState(() {
                BlocProvider.of<SavedCubit>(context)
                    .removeFromSchedule(savedItems[index]);
              });
            },
            child: const Icon(Icons.remove, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        Text('Remove from schedule'),
      ],
    );
  }
}
