import 'package:deep_conference/constants/schedule_item_categories.dart';

class MyIcons {
  static final Map<String, String> categoryIcons = {
    'all': 'images/icons/all.png',
    'lead': 'images/icons/lead.png',
    'ops': 'images/icons/ops.png',
    'tech': 'images/icons/tech.png',
  };

  static final Map<String, String> categoryIconsHighlighted = {
    'all': 'images/icons/all_highlighted.png',
    'lead': 'images/icons/lead_highlighted.png',
    'ops': 'images/icons/ops_highlighted.png',
    'tech': 'images/icons/tech_highlighted.png',
  };

  static String? getCategoryIcon(ScheduleItemCategory category, bool highlighted) {
    String categoryName = category.name;
    if (highlighted) {
      return categoryIconsHighlighted[categoryName];
    } else {
      return categoryIcons[categoryName];
    }
  }

  static const String appIcon = 'images/icons/app_icon.png';
}
