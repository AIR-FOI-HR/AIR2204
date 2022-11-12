import 'package:expandable_attempt/cubits/cubit/saved_cubit.dart';
import 'package:expandable_attempt/screens/my_schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/schedule_item_category_model.dart';
import '../data/models/schedule_item_model.dart';
import 'item_detail.dart';

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
        SizedBox(
          height: 40,
          width: 40,
          child: MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Icon(
              Icons.arrow_back,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.title,
    required this.color,
  });

  final String title;
  final MaterialAccentColor color;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scheduleItems = List.generate(
    10,
    (index) => ScheduleItem(
        id: '$index',
        title: 'Schedule item $index',
        speaker: 'Daria Komić',
        date: '20/03/20222',
        time: '14:00-14:45',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut',
        hall: 'B site',
        category: ScheduleItemCategory.tech),
  );

  //možda netreba
  List<ScheduleItem> savedItems = [];

  @override
  Widget build(BuildContext context) {
    //TODO: napraviti da se screen refresha dok se navigiraš pa onda netreba ova linija (možda neki cubit koji emita state svaki put kad promjeniš screen)
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: AppBarButtons(),
      ),
      body: BlocBuilder<SavedCubit, SavedState>(
        builder: (context, state) {
          return ListView.builder(
            //body nam je lista koja ima itema onolko kolko ima lista Quotes, i item builder
            //je widget _buildList koji prima quote na svakom indexu
            itemCount: scheduleItems.length,
            itemBuilder: (context, index) {
              return _buildList(index, state);
            },
          );
        },
      ),
    );
  }

  Widget _buildList(int index, SavedState state) {
    return ExpansionTile(
      title: Text(scheduleItems[index].time),
      subtitle: Text(scheduleItems[index].title),
      children: [
        SizedBox(
          width: 40,
          child: MaterialButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetail(
                      title: 'Schedule Item Details', color: Colors.pinkAccent, scheduleItem: scheduleItems[index]),
                ),
              ),
            },
            child: const Icon(Icons.more_horiz, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        const Text('More'),
        //Text(alreadySaved ? "saved" : "not saved"),
        SizedBox(
          width: 40,
          child: MaterialButton(
            //onPressed: () => {Navigator.of(context).pushNamed('/mySchedule')},
            onPressed: () {
              setState(
                () {
                  if (state.savedItems.contains(scheduleItems[index])) {
                    //saved.remove(scheduleItems[index]);
                    BlocProvider.of<SavedCubit>(context).removeFromSchedule(scheduleItems[index]);
                  } else {
                    //saved.add(scheduleItems[index]);
                    BlocProvider.of<SavedCubit>(context).saveToSchedule(scheduleItems[index]);
                  }
                },
              );
            },
            child: Icon(
              state.savedItems.contains(scheduleItems[index]) ? Icons.remove : Icons.add,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(state.savedItems.contains(scheduleItems[index]) ? 'Remove from schedule' : 'Add to schedule'),
      ],
    );
  }
}
