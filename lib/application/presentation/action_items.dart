import 'package:deep_conference/constants/my_icons.dart';
import 'package:deep_conference/constants/schedule_item_categories.dart';
import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({super.key, required this.category, required this.onPressed});

  final VoidCallback onPressed;
  final ScheduleItemCategory category;

  @override
  Widget build(BuildContext context) {
    String? categoryName = MyIcons.getCategoryIcon(category);
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
  const DateButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.skewX(0.3),
      child: MaterialButton(
        onPressed: onPressed,
        color: MyColors.color772DFF,
        child: Transform(
          transform: Matrix4.skewX(-0.3),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
