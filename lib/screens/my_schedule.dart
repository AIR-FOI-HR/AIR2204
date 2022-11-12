import 'package:expandable_attempt/data/models/schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/cubit/auth_cubit.dart';
import '../cubits/cubit/saved_cubit.dart';
import 'appbar_items.dart';
import 'item_detail.dart';

class MySchedule extends StatefulWidget {
  const MySchedule({
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: const Text('Personal Schedule'),
        centerTitle: true,
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          const AppBarActions(),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (authContext, authState) {
          if (authState.guestLogin == false) {
            return BlocBuilder<SavedCubit, SavedState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.savedItems.length,
                  itemBuilder: (context, index) {
                    return _buildList(state.savedItems[index]);
                  },
                );
              },
            );
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Text(
                'Please log in to view personal schedule',
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildList(ScheduleItem savedItem) {
    return ExpansionTile(
      title: Text(savedItem.time),
      subtitle: Text(savedItem.title),
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
                      scheduleItem: savedItem),
                ),
              ),
            },
            child: const Icon(Icons.more_horiz, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        const Text('More'),
        SizedBox(
          width: 40,
          child: MaterialButton(
            onPressed: () {
              setState(() {
                BlocProvider.of<SavedCubit>(context)
                    .removeFromSchedule(savedItem);
              });
            },
            child: const Icon(Icons.remove, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        const Text('Remove from schedule'),
      ],
    );
  }
}
