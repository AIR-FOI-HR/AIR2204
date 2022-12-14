import 'package:deep_conference/constants/my_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/schedule_items.dart';
import '../logic/saved_schedule_cubit.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.scheduleItem});
  final ScheduleItem scheduleItem;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.detailTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          BlocBuilder<SavedScheduleCubit, SavedScheduleState>(
            builder: (context, state) {
              if (state.savedItems.contains(widget.scheduleItem)) {
                return MaterialButton(
                  child: const Icon(Icons.remove, color: MyColors.colorFFFFFF),
                  onPressed: () => setState(() {
                    context.read<SavedScheduleCubit>().updatePersonalSchedule(widget.scheduleItem, false);
                  }),
                );
              } else {
                return MaterialButton(
                  child: const Icon(Icons.add, color: MyColors.colorFFFFFF),
                  onPressed: () => setState(() {
                    context.read<SavedScheduleCubit>().updatePersonalSchedule(widget.scheduleItem, true);
                  }),
                );
              }
            },
          ),
        ],
      ),
      body: Text(widget.scheduleItem.description, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
