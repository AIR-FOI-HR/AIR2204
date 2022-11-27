import 'package:deep_conference/application/presentation/action_items.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:deep_conference/constants/schedule_item_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/my_dates.dart';
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
    //FILTRACIJA
    context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.all, MyDates.firstDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schedule',
        ),
        actions: [
          MaterialButton(
            child: const Icon(Icons.notifications, color: MyColors.colorFFFFFF),
            onPressed: () => {
              //implement notification screen
            },
          ),
        ],
      ),
      body: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          return Column(
            children: [
              //buttons for filtration by date
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform(
                      transform: Matrix4.skewX(0.3),
                      child: MaterialButton(
                        onPressed: () {
                          //FILTRACIJA
                          context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.all, MyDates.firstDay);
                        },
                        //FILTRACIJA
                        color: state.currentDate == MyDates.firstDay
                            ? MyColors.color772DFF
                            : MyColors.color772DFF.withOpacity(0.3),
                        child: Transform(
                          transform: Matrix4.skewX(-0.3),
                          //dynamic
                          child: Text(
                            'WED, OCT 19TH',
                            //FILTRACIJA
                            style: state.currentDate == MyDates.firstDay
                                ? Theme.of(context).textTheme.titleMedium
                                : Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.white.withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Transform(
                      transform: Matrix4.skewX(0.3),
                      child: MaterialButton(
                        onPressed: () {
                          //FILTRACIJA
                          context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.all, MyDates.secondDay);
                        },
                        //FILTRACIJA
                        color: state.currentDate == MyDates.secondDay
                            ? MyColors.color772DFF
                            : MyColors.color772DFF.withOpacity(0.3),
                        child: Transform(
                          transform: Matrix4.skewX(-0.3),
                          //dynamic
                          child: Text(
                            'THU, OCT 20TH',
                            //FILTRACIJA
                            style: state.currentDate == MyDates.secondDay
                                ? Theme.of(context).textTheme.titleMedium
                                : Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.white.withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              //buttons for filtration by category
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CategoryButton(
                      //FILTRACIJA
                      highlighted: state.currentCategory == ScheduleItemCategory.all ? true : false,
                      category: ScheduleItemCategory.all,
                      onPressed: () => {
                        //FILTRACIJA
                        context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.all, state.date)
                      },
                    ),
                    const SizedBox(width: 16),
                    CategoryButton(
                      //FILTRACIJA
                      highlighted: state.currentCategory == ScheduleItemCategory.tech ? true : false,
                      category: ScheduleItemCategory.tech,
                      onPressed: () => {
                        //FILTRACIJA
                        context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.tech, state.date)
                      },
                    ),
                    const SizedBox(width: 16),
                    CategoryButton(
                      //FILTRACIJA
                      highlighted: state.currentCategory == ScheduleItemCategory.ops ? true : false,
                      category: ScheduleItemCategory.ops,
                      onPressed: () => {
                        //FILTRACIJA
                        context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.ops, state.date)
                      },
                    ),
                    const SizedBox(width: 16),
                    CategoryButton(
                      //FILTRACIJA
                      highlighted: state.currentCategory == ScheduleItemCategory.lead ? true : false,
                      category: ScheduleItemCategory.lead,
                      onPressed: () => {
                        //FILTRACIJA
                        context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.lead, state.date)
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: state.scheduleItems.length,
                  itemBuilder: (context, index) {
                    return listBuild(state.scheduleItems[index]);
                  },
                ),
              ),
            ],
          );
        },
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
      child: ListTile(
        title: Column(
          children: [
            //category and time
            Row(
              children: [
                //dynamic color
                //logic za boju icona
                Icon(
                  Icons.circle,
                  color: scheduleItem.category == ScheduleItemCategory.tech
                      ? MyColors.colorF44336
                      : scheduleItem.category == ScheduleItemCategory.lead
                          ? MyColors.color9B9A9B
                          : scheduleItem.category == ScheduleItemCategory.ops
                              ? MyColors.color251F5D
                              : MyColors.color000000,
                  size: 12,
                ),
                const SizedBox(width: 12),
                Text(
                  "${scheduleItem.startTime.hour.toString()}:${scheduleItem.startTime.minute.toString().padLeft(2, '0')} - ${scheduleItem.endTime.hour.toString()}:${scheduleItem.endTime.minute.toString().padLeft(2, '0')}",
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
                      const Icon(
                        Icons.place,
                        size: 14,
                        color: MyColors.color9B9A9B,
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
          children: const [
            Icon(
              Icons.arrow_forward_ios,
              color: MyColors.colorFFFFFF,
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
