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
}
