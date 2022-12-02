import 'package:deep_conference/constants/schedule_item_categories.dart';

class MyIcons {
  static final Map<String, String> categoryIcons = {
    'all': 'images/icons/all.png',
    'lead': 'images/icons/lead.png',
    'ops': 'images/icons/ops.png',
    'tech': 'images/icons/tech.png',
  };

  static String? getCategoryIcon(ScheduleItemCategory category) {
    String categoryName = category.name;

    return categoryIcons[categoryName];
  }

  static const String appIcon = 'images/icons/app_icon.png';
}
