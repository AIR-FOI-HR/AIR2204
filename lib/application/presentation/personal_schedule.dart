import 'package:deep_conference/application/presentation/schedule_card.dart';
import 'package:deep_conference/constants/my_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/my_icons.dart';
import '../../constants/schedule_item_categories.dart';
import '../../domain/models/schedule_items.dart';
import '../logic/saved_schedule_cubit.dart';
import '../widgets/error_widgets.dart';
import 'action_items.dart';

class PersonalSchedule extends StatefulWidget {
  const PersonalSchedule({super.key});

  @override
  State<PersonalSchedule> createState() => _PersonalScheduleState();
}

class _PersonalScheduleState extends State<PersonalSchedule> {
  @override
  void initState() {
    super.initState();
    context.read<SavedScheduleCubit>().readAllSavedItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Image(
          image: AssetImage(MyIcons.appBarBackground),
          fit: BoxFit.cover,
        ),
        title: Text(
          AppLocalizations.of(context)!.personalScheduleTitle,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              highlightColor: MyColors.color040306,
              splashColor: MyColors.color3A3A3A,
              radius: 50,
              borderRadius: BorderRadius.circular(50),
              onTap: () => {
                //TODO: implement notification screen
              },
              child: const SizedBox(width: 50, child: Icon(Icons.notifications, size: 25)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          BlocBuilder<SavedScheduleCubit, SavedScheduleState>(
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
                          onPressed: () => {context.read<SavedScheduleCubit>().sortByDate(state.allDates[index])},
                          date: state.currentDate,
                          myDate: state.allDates[index],
                        );
                      }),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          BlocBuilder<SavedScheduleCubit, SavedScheduleState>(
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
                        onPressed: () => {context.read<SavedScheduleCubit>().sortByCategory(category)},
                        category: state.currentCategory,
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          BlocBuilder<SavedScheduleCubit, SavedScheduleState>(
            builder: (context, state) {
              if (state.error != null) {
                return RetryButton(
                  error: state.error,
                  onRetry: () => {
                    context.read<SavedScheduleCubit>().readAllSavedItems(),
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
