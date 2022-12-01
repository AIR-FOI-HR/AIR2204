enum ScheduleItemCategory { lead, tech, ops, keynote, all, other }

extension ScheduleItemCategoryX on ScheduleItemCategory {
  static ScheduleItemCategory fromString(String string) {
    if (string == 'lead') {
      return ScheduleItemCategory.lead;
    } else if (string == 'tech') {
      return ScheduleItemCategory.tech;
    } else if (string == 'ops') {
      return ScheduleItemCategory.ops;
    } else if (string == 'keynote') {
      return ScheduleItemCategory.keynote;
    } else if (string == 'other') {
      return ScheduleItemCategory.other;
    } else {
      return ScheduleItemCategory.all;
    }
  }

  static ScheduleItemCategory fromIndex(int index) {
    if (index == 0) {
      return ScheduleItemCategory.all;
    } else if (index == 1) {
      return ScheduleItemCategory.tech;
    } else if (index == 2) {
      return ScheduleItemCategory.ops;
    } else {
      return ScheduleItemCategory.lead;
    }
  }
}
