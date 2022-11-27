import 'package:deep_conference/constants/schedule_item_categories.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({super.key, required this.category, required this.onPressed, required this.highlighted});

  final VoidCallback onPressed;
  final ScheduleItemCategory category;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    //FILTRACIJA
    String categoryName = category.name.toString();
    if (highlighted == true) {
      return IconButton(
        onPressed: onPressed,
        icon: Image.asset('images/icons/${categoryName}_highlighted.png'),
        iconSize: 50,
      );
    } else {
      return IconButton(
        onPressed: onPressed,
        icon: Image.asset('images/icons/$categoryName.png'),
        iconSize: 50,
      );
    }
  }
}
