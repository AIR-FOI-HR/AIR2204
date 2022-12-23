import 'package:deep_conference/application/widgets/filtration_widgets.dart';
import 'package:deep_conference/application/widgets/error_widgets.dart';
import 'package:deep_conference/application/widgets/schedule_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:deep_conference/constants/schedule_item_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/schedule_items.dart';
import '../logic/saved_schedule_cubit.dart';
import '../logic/schedule_cubit.dart';
import '../widgets/appbar_items.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ScheduleCubit>().readAllItems();
    //so saved items are initizalised and you can see if they're saved or not in the detail screen
    context.read<SavedScheduleCubit>().readAllSavedItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appBarGradient(),
        title: Text(
          AppLocalizations.of(context)!.scheduleTitle,
        ),
        actions: [
          notificationBell(),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, state) {
              return SizedBox(
                height: 35,
                child: Center(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.allDates.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 24,
                        );
                      },
                      itemBuilder: (context, index) {
                        return DateButton(
                          onPressed: () => {context.read<ScheduleCubit>().sortByDate(state.allDates[index])},
                          date: state.currentDate,
                          myDate: state.allDates[index],
                        );
                      }),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, state) {
              return SizedBox(
                height: 80,
                child: Center(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // -2 because there are two categories that we don't filter by
                    itemCount: ScheduleItemCategory.values.length - 2,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 10,
                      );
                    },
                    itemBuilder: (context, index) {
                      final ScheduleItemCategory category = ScheduleItemCategory.values[index];
                      return CategoryButton(
                        myCategory: category,
                        onPressed: () => {context.read<ScheduleCubit>().sortByCategory(category)},
                        category: state.currentCategory,
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, state) {
              if (state.error != null) {
                return RetryButton(
                  error: state.error,
                  onRetry: () => {
                    context.read<ScheduleCubit>().readAllItems(),
                  },
                );
              }
              if (state.loading) {
                return const LoadingState();
              }
              if (state.scheduleItems.isNotEmpty) {
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 12,
                      );
                    },
                    padding: const EdgeInsets.only(left: 20, top: 5, right: 15, bottom: 5),
                    itemCount: state.scheduleItems.length,
                    itemBuilder: (context, index) {
                      return listBuild(state.scheduleItems[index]);
                    },
                  ),
                );
              }
              return const NoData();
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
