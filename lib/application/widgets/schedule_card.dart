import 'package:deep_conference/application/widgets/my_icon_text_label.dart';
import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import '../../domain/models/schedule_items.dart';
import '../presentation/schedule_detail_screen.dart';
import 'my_category_time_text_label.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key, required this.scheduleItem});

  final ScheduleItem scheduleItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      title: Column(children: [
        MyCategoryTimeTextLabel(
            category: scheduleItem.category,
            icon: Icons.circle,
            iconSize: 12,
            startTime: scheduleItem.startTime,
            endTime: scheduleItem.endTime,
            textStyle: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 24,
              ),
              Text(
                scheduleItem.title,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              scheduleItem.hall != ""
                  ? MyIconTextLabel(
                      iconSize: 14,
                      icon: Icons.place,
                      textStyle: Theme.of(context).textTheme.labelMedium,
                      text: scheduleItem.hall.toUpperCase())
                  : const SizedBox(height: 14),
            ],
          ),
        ),
      ]),
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
            builder: (context) =>
                ScheduleDetailScreen(scheduleItem: scheduleItem),
          ),
        ),
      },
    );
  }
}
