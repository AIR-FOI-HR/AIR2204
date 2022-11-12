import 'package:expandable_attempt/data/models/schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/cubit/auth_cubit.dart';
import '../cubits/cubit/saved_cubit.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail(
      {super.key,
      required this.title,
      required this.color,
      required this.scheduleItem});

  final ScheduleItem scheduleItem;
  final String title;
  final MaterialAccentColor color;

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scheduleItem.title),
        centerTitle: true,
        /*actions: [
          const AppBarActions(),
        ],*/
      ),
      body: Column(
        children: [
          BlocBuilder<SavedCubit, SavedState>(
            builder: (context, state) {
              return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  if (authState.guestLogin == false) {
                    return MaterialButton(
                      onPressed: () {
                        setState(() {
                          if (state.savedItems.contains(widget.scheduleItem)) {
                            BlocProvider.of<SavedCubit>(context)
                                .removeFromSchedule(widget.scheduleItem);
                          } else {
                            BlocProvider.of<SavedCubit>(context)
                                .saveToSchedule(widget.scheduleItem);
                          }
                        });
                      },
                      child: Icon(
                        state.savedItems.contains(widget.scheduleItem)
                            ? Icons.remove
                            : Icons.add,
                        size: 20,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
          ),
          Text(widget.scheduleItem.description)
        ],
      ),
    );
  }
}
