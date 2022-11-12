import 'package:expandable_attempt/screens/root_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        actions: [
          AppBarActions(),
        ],
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BlocBuilder<SavedCubit, SavedState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.savedItems.length,
                  itemBuilder: (context, index) {
                    return _buildList(index, state);
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

  Widget _buildList(int index, SavedState state) {
    return ExpansionTile(
      title: Text(state.savedItems[index].time),
      subtitle: Text(state.savedItems[index].title),
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
                      scheduleItem: state.savedItems[index]),
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
                    .removeFromSchedule(state.savedItems[index]);
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
