import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_visibility.dart';
import 'package:gym_partner/models/user.dart';
import 'package:gym_partner/models/user_plan_data.dart';

enum MyPlansCategory {
  all,
  my,
  ongoing,
  downloaded,
  published,
}

Map<MyPlansCategory, String> planFilterCriteriaChipNames = {
  MyPlansCategory.all: 'All plans',
  MyPlansCategory.my: 'My plans',
  MyPlansCategory.ongoing: 'Ongoing',
  MyPlansCategory.downloaded: 'Downloaded',
  MyPlansCategory.published: 'Published'
};

Map<MyPlansCategory, String> planFilterCriteriaTitleNames = {
  MyPlansCategory.all: 'All plans',
  MyPlansCategory.my: 'Plans created by me',
  MyPlansCategory.ongoing: 'Ongoing plans',
  MyPlansCategory.downloaded: 'Downloaded plans',
  MyPlansCategory.published: 'Published plans',
};

Map<MyPlansCategory, bool Function(Plan plan, AppUser userData)>
    planFilterCriteriaConditions = {
  MyPlansCategory.all: (plan, userData) => true,
  MyPlansCategory.my: (plan, userData) => userData.id == plan.authorId,
  MyPlansCategory.ongoing: (plan, userData) =>
      userData.plansData.firstWhere((element) {
        return element.planId == plan.id;
      }).currentDayIndex >
      0,
  MyPlansCategory.downloaded: (plan, userData) => userData.id != plan.authorId,
  MyPlansCategory.published: (plan, userData) =>
      plan.visibility == PlanVisibility.public && userData.id == plan.authorId
};
