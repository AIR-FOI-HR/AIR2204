import 'package:deep_conference/constants/schedule_item_categories.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton(
      {super.key, required this.category, required this.onPressed});

  final VoidCallback onPressed;
  final ScheduleItemCategory category;

  @override
  Widget build(BuildContext context) {
    String categoryName = category.name.toString();
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset('images/icons/$categoryName.png'),
      iconSize: 50,
    );
  }
}
