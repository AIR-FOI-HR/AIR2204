import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_attempt/cubits/cubit/saved_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/cubit/auth_cubit.dart';
import '../data/models/schedule_item.dart';
import 'appbar_items.dart';
import 'item_detail.dart';

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
  Stream<List<ScheduleItem>> readScheduleItems() {
    return FirebaseFirestore.instance
        .collection('scheduleItems')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScheduleItem.fromJson(doc.data()))
            .toList());
  }

  // final CollectionReference scheduleItemsCollection =
  //   FirebaseFirestore.instance.collection('scheduleItems');

  /*
  await scheduleItems.add({"category": category, "date" : date});
  await scheduleItems.update({"category": category, "date" : date});
  await scheduleItems.doc(scheduleItemId).delete();
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.title),
        centerTitle: true,
        // leading: const AppBarButtons(),
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          const AppBarActions(),
        ],
      ),
      body: StreamBuilder<List<ScheduleItem>>(
        stream: readScheduleItems(),
        builder: (context, scheduleItemsSnapshot) {
          if (scheduleItemsSnapshot.hasData) {
            return BlocBuilder<SavedCubit, SavedState>(
              builder: (context, state) {
                return ListView.builder(
                  //body nam je lista koja ima itema onolko kolko ima lista Quotes, i item builder
                  //je widget _buildList koji prima quote na svakom indexu
                  itemCount:
                      scheduleItemsSnapshot.data!.length, //number of rows
                  itemBuilder: (context, index) {
                    final scheduleItem = scheduleItemsSnapshot.data![index];
                    return _buildList(scheduleItem, state);
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildList(ScheduleItem scheduleItem, SavedState state) {
    return ExpansionTile(
      title: Text(scheduleItem.time),
      subtitle: Text(scheduleItem.title),
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
                      scheduleItem: scheduleItem),
                ),
              ),
            },
            child: const Icon(Icons.more_horiz, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        const Text('More'),
        //Text(alreadySaved ? "saved" : "not saved"),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState.guestLogin == false) {
              return Column(
                children: [
                  SizedBox(
                    width: 40,
                    child: MaterialButton(
                      //onPressed: () => {Navigator.of(context).pushNamed('/mySchedule')},
                      onPressed: () {
                        setState(
                          () {
                            if (state.savedItems.contains(scheduleItem)) {
                              //saved.remove(scheduleItems[index]);
                              BlocProvider.of<SavedCubit>(context)
                                  .removeFromSchedule(scheduleItem);
                            } else {
                              //saved.add(scheduleItems[index]);
                              BlocProvider.of<SavedCubit>(context)
                                  .saveToSchedule(scheduleItem);
                            }
                          },
                        );
                      },
                      child: Icon(
                        state.savedItems.contains(scheduleItem)
                            ? Icons.remove
                            : Icons.add,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(state.savedItems.contains(scheduleItem)
                      ? 'Remove from schedule'
                      : 'Add to schedule'),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
