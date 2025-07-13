enum YesNo {
  NO,
  YES,
}

enum CommitHours {
  LESS_THAN_5_HOURS,
  FIVE_TO_TEN_HOURS,
  MORE_THAN_TEN_HOURS,
}

enum Occupation {
  EMPLOYED_FULL_TIME,
  EMPLOYED_PART_TIME,
  UNEMPLOYED,
  STUDENT,
  ATHELETE,
  SPORTS_MAN,
}

enum Schedule {
  WEEKDAYS_MORNING,
  WEEKDAYS_EVENING,
  WEEKEND_MORNING,
  WEEKEND_EVENING,
  WEEKDAYS_AFTERNOON,
  WEEKEND_AFTERNOON,
}

class MembershipConstants {
  static const List<String> yesNoOptions = [
    'NO',
    'YES',
  ];

  static const List<String> commitHoursOptions = [
    'LESS_THAN_5_HOURS',
    'FIVE_TO_TEN_HOURS',
    'MORE_THAN_TEN_HOURS',
  ];

  static const List<String> occupationOptions = [
    'EMPLOYED_FULL_TIME',
    'EMPLOYED_PART_TIME',
    'UNEMPLOYED',
    'STUDENT',
    'ATHELETE',
    'SPORTS_MAN',
  ];

  static const List<String> scheduleOptions = [
    'WEEKDAYS_MORNING',
    'WEEKDAYS_EVENING',
    'WEEKEND_MORNING',
    'WEEKEND_EVENING',
    'WEEKDAYS_AFTERNOON',
    'WEEKEND_AFTERNOON',
  ];

  static const List<String> availableStates = [
    "DELHI",
    "DELHI_NCR",
    "GURGAON"
  ];
} 