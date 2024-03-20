class UserPlanData {
  UserPlanData({required this.planId, required this.currentDayIndex});

  String planId;
  int currentDayIndex;

  Map<String, dynamic> toFirestore() {
    return {
      'plan_id': planId,
      'current_day_index': currentDayIndex,
    };
  }
}
