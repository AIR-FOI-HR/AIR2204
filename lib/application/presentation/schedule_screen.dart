import 'package:deep_conference/application/presentation/action_items.dart';
import 'package:deep_conference/application/presentation/error_widgets.dart';
import 'package:deep_conference/application/presentation/schedule_card.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:deep_conference/constants/my_dates.dart';
import 'package:deep_conference/constants/schedule_item_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/schedule_items.dart';
import '../logic/schedule_cubit.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
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
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: BlocBuilder<ScheduleCubit, ScheduleState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DateButton(
                      label: 'WED, OCT 19TH',
                      onPressed: () =>
                          {context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.all, MyDates.firstDay)},
                      date: state.currentDate,
                      myDate: MyDates.firstDay,
                    ),
                    const SizedBox(width: 24),
                    DateButton(
                      label: 'THU, OCT 20TH',
                      onPressed: () => {
                        context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.all, MyDates.secondDay)
                      },
                      date: state.currentDate,
                      myDate: MyDates.secondDay,
                    )
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: BlocBuilder<ScheduleCubit, ScheduleState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CategoryButton(
                      myCategory: ScheduleItemCategory.all,
                      onPressed: () => {
                        context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.all, state.currentDate)
                      },
                      category: state.currentCategory,
                    ),
                    const SizedBox(width: 16),
                    CategoryButton(
                      myCategory: ScheduleItemCategory.tech,
                      onPressed: () => {
                        context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.tech, state.currentDate)
                      },
                      category: state.currentCategory,
                    ),
                    const SizedBox(width: 16),
                    CategoryButton(
                      myCategory: ScheduleItemCategory.ops,
                      onPressed: () => {
                        context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.ops, state.currentDate)
                      },
                      category: state.currentCategory,
                    ),
                    const SizedBox(width: 16),
                    CategoryButton(
                      myCategory: ScheduleItemCategory.lead,
                      onPressed: () => {
                        context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.lead, state.currentDate)
                      },
                      category: state.currentCategory,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, state) {
              if (state.error != null) {
                return RetryButton(
                  error: state.error,
                  onRetry: () => {
                    context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.all, MyDates.firstDay),
                  },
                );
              }
              if (state.loading) {
                return const LoadingState();
              }
              if (state.scheduleItems.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.scheduleItems.length,
                    itemBuilder: (context, index) {
                      return listBuild(state.scheduleItems[index]);
                    },
                  ),
                );
              }
              return NoData(
                onRetry: () => {
                  context.read<ScheduleCubit>().readScheduleItems(ScheduleItemCategory.all, MyDates.firstDay),
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget listBuild(ScheduleItem scheduleItem) {
    return ScheduleCard(scheduleItem: scheduleItem);
  }
}
