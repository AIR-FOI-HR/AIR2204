import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import '../../domain/models/schedule_items.dart';
import 'detail_screen.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key, required this.scheduleItem});

  final ScheduleItem scheduleItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 15, top: 5, right: 0, bottom: 5),
      child: ListTile(
        title: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.circle,
                  //logic za boju ikona
                  color: MyColors.colorF44336,
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
