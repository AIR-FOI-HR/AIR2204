import 'package:expandable_attempt/cubits/cubit/saved_cubit.dart';
import 'package:expandable_attempt/screens/my_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/schedule_item_model.dart';
import 'item_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title, required this.color});

  final String title;
  final MaterialAccentColor color;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scheduleItems = List.generate(
      10,
      (index) => Schedule('Schedule item $index', '$index : $index - 14:45',
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum'));

  List<Schedule> savedItems = [];

  @override
  Widget build(BuildContext context) {
    //TODO: napraviti da se screen refresha dok se navigiraš pa onda netreba ova linijaa (možda neki cubit koji emita state svaki put kad promjeniš screen)
    savedItems = BlocProvider.of<SavedCubit>(context).state.savedItems;

    return BlocListener<SavedCubit, SavedState>(
      listener: (context, state) {
        savedItems = state.savedItems;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          leading: MaterialButton(
            onPressed: () => {Navigator.of(context).pushNamed('/mySchedule')},
            /*onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MySchedule(
                      title: 'Personal schedule',
                      color: Colors.deepOrangeAccent,
                      savedItems: saved),
                ),
              );
            },*/
            child: const Icon(
              Icons.directions_bike,
              size: 20,
            ),
          ),
        ),
        body: ListView.builder(
          //body nam je lista koja ima itema onolko kolko ima lista Quotes, i item builder
          //je widget _buildList koji prima quote na svakom indexu
          itemCount: scheduleItems.length,
          itemBuilder: (context, index) {
            return _buildList(index);
          },
        ),
      ),
    );
  }

  Widget _buildList(index) {
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
                          title: 'Schedule Item Details',
                          color: Colors.pinkAccent,
                          scheduleItem: scheduleItems[index])))
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
                  if (savedItems.contains(scheduleItems[index])) {
                    //saved.remove(scheduleItems[index]);
                    BlocProvider.of<SavedCubit>(context)
                        .removeFromSchedule(scheduleItems[index]);
                  } else {
                    //saved.add(scheduleItems[index]);
                    BlocProvider.of<SavedCubit>(context)
                        .saveToSchedule(scheduleItems[index]);
                  }
                },
              );
            },
            child: Icon(
              savedItems.contains(scheduleItems[index])
                  ? Icons.remove
                  : Icons.add,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(savedItems.contains(scheduleItems[index])
            ? 'Remove from schedule'
            : 'Add to schedule'),
      ],
    );
  }
}
