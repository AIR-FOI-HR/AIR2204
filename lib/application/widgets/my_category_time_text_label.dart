import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/my_colors.dart';
import '../../constants/schedule_item_categories.dart';

class MyCategoryTimeTextLabel extends StatelessWidget {
  const MyCategoryTimeTextLabel({
    super.key,
    required this.category,
    required this.icon,
    required this.textStyle,
    this.iconColor = MyColors.color9B9A9B,
    required this.startTime,
    required this.endTime,
    this.spacing = 5,
    this.iconSize = 14,
  });

  final ScheduleItemCategory category;
  final DateTime startTime, endTime;
  final IconData icon;
  final double spacing, iconSize;
  final Color iconColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: category == ScheduleItemCategory.tech
              ? MyColors.colorF44336
              : category == ScheduleItemCategory.lead
                  ? MyColors.color9B9A9B
                  : category == ScheduleItemCategory.ops
                      ? MyColors.color251F5D
                      : MyColors.color000000,
          size: iconSize,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          "${DateFormat.Hm().format(startTime)} - ${DateFormat.Hm().format(endTime)} ",
          style: textStyle,
        ),
      ],
    );
  }
}
