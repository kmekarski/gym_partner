class UserPlanData {
  UserPlanData(
      {required this.planId,
      required this.currentDayIndex,
      required this.isRecent});

  String planId;
  int currentDayIndex;
  bool isRecent;

  Map<String, dynamic> toFirestore() {
    return {
      'plan_id': planId,
      'current_day_index': currentDayIndex,
      'is_recent': isRecent,
    };
  }
}
