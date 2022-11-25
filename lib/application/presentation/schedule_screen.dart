import 'package:deep_conference/application/presentation/action_items.dart';
import 'package:deep_conference/constants/schedule_item_categories.dart';
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
  //reads all scheduleitems from firebase in initState
  @override
  void initState() {
    super.initState();
    context.read<ScheduleCubit>().readScheduleItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary, //change your color here
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Schedule',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          MaterialButton(
            child: const Icon(
              Icons.notifications,
            ),
            onPressed: () => {
              //implement notification screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          //buttons for filtration by date
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform(
                transform: Matrix4.skewX(0.3),
                child: MaterialButton(
                  onPressed: () {
                    //implement filtration by date
                  },
                  color: Theme.of(context).colorScheme.primary,
                  child: Transform(
                    transform: Matrix4.skewX(-0.3),
                    //dynamic
                    child: Text(
                      'WED, OCT 19TH',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Transform(
                transform: Matrix4.skewX(0.3),
                child: MaterialButton(
                  onPressed: () {
                    //implement filtration by date
                  },
                  color: Theme.of(context).colorScheme.primary,
                  child: Transform(
                    transform: Matrix4.skewX(-0.3),
                    //dynamic
                    child: Text(
                      'THU, OCT 20TH',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          //buttons for filtration by category
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 40),
              CategoryButton(
                category: ScheduleItemCategory.all,
                onPressed: () => {
                  //implement filtration by category
                },
              ),
              const SizedBox(width: 16),
              CategoryButton(
                category: ScheduleItemCategory.tech,
                onPressed: () => {
                  //implement filtration by category
                },
              ),
              const SizedBox(width: 16),
              CategoryButton(
                category: ScheduleItemCategory.ops,
                onPressed: () => {
                  //implement filtration by category
                },
              ),
              const SizedBox(width: 16),
              CategoryButton(
                category: ScheduleItemCategory.lead,
                onPressed: () => {
                  //implement filtration by category
                },
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 10),
          //list view of schedule items
          BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, state) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.scheduleItems.length,
                  itemBuilder: (context, index) {
                    return listBuild(state.scheduleItems[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget listBuild(ScheduleItem scheduleItem) {
    //returns a card which we use to set padding between list tiles
    //each card has a child listTile
    //listTile's title is a column of three rows, first row is category and time
    //second row is agenda item title, which has fixed height and set overflow after 2 lines
    //third row is optional, if there's a hall then it displays the hall
    //after the title atribute column there's a leading button and an onpressed func
    return Card(
      margin: const EdgeInsets.fromLTRB(15, 5, 0, 5),
      color: Theme.of(context).colorScheme.background,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Column(
          children: [
            //category and time
            Row(
              children: [
                //dynamic color
                //logic za boju icona
                const Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 12,
                ),
                const SizedBox(width: 12),
                Text(
                  scheduleItem.time,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 5),
            //title of schedule item
            SizedBox(
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 24,
                  ),
                  Flexible(
                    child: Text(
                      scheduleItem.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            //scheduleItem hall and location icon
            scheduleItem.hall != ""
                ? Row(
                    children: [
                      const SizedBox(
                        width: 24,
                      ),
                      Icon(
                        Icons.place,
                        size: 14,
                        color: Theme.of(context).colorScheme.shadow,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        scheduleItem.hall.toUpperCase(),
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                    ],
                  )
                : const SizedBox(height: 14),
          ],
        ),
        //scheduleItem detail screen trailing button
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ],
        ),
        //currently the whole ListTile is tappable, alternative is making just the arrow icon tappable
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(scheduleItem: scheduleItem),
            ),
          ),
        },
      ),
    );
  }
}
