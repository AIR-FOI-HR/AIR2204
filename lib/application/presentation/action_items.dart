import 'package:deep_conference/constants/my_icons.dart';
import 'package:deep_conference/constants/schedule_item_categories.dart';
import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({super.key, required this.category, required this.onPressed, required this.myCategory});

  final VoidCallback onPressed;
  final ScheduleItemCategory category;
  final ScheduleItemCategory myCategory;

  @override
  Widget build(BuildContext context) {
    final bool highlighted;
    if (category == myCategory) {
      highlighted = true;
    } else {
      highlighted = false;
    }

    String? categoryName = MyIcons.getCategoryIcon(myCategory, highlighted);
    if (categoryName != null) {
      return IconButton(
        onPressed: onPressed,
        icon: Image.asset(categoryName),
        iconSize: 50,
      );
    } else {
      return IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.circle_rounded),
      );
    }
  }
}

class DateButton extends StatelessWidget {
  const DateButton({super.key, required this.label, required this.onPressed, required this.date, required this.myDate});

  final String label;
  final VoidCallback onPressed;
  final DateTime date;
  final DateTime myDate;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.skewX(0.3),
      child: MaterialButton(
        onPressed: onPressed,
        color: date == myDate ? MyColors.color772DFF : MyColors.color772DFF.withOpacity(0.3),
        child: Transform(
          transform: Matrix4.skewX(-0.3),
          child: Text(
            label,
            style: date == myDate
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white.withOpacity(0.3)),
          ),
        ),
      ),
    );
  }
}
