import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/user.dart';
import 'package:gym_partner/models/user_plan_data.dart';

enum PlanFilterCriteria {
  all,
  my,
  ongoing,
  downloaded,
}

Map<PlanFilterCriteria, String> planFilterCriteriaChipNames = {
  PlanFilterCriteria.all: 'All plans',
  PlanFilterCriteria.my: 'My plans',
  PlanFilterCriteria.ongoing: 'Ongoing',
  PlanFilterCriteria.downloaded: 'Downloaded',
};

Map<PlanFilterCriteria, String> planFilterCriteriaTitleNames = {
  PlanFilterCriteria.all: 'All plans',
  PlanFilterCriteria.my: 'Plans created by me',
  PlanFilterCriteria.ongoing: 'Ongoing plans',
  PlanFilterCriteria.downloaded: 'Downloaded plans',
};

Map<PlanFilterCriteria, bool Function(Plan plan, AppUser userData)>
    planFilterCriteriaConditions = {
  PlanFilterCriteria.all: (plan, userData) => true,
  PlanFilterCriteria.my: (plan, userData) => userData.id == plan.authorId,
  PlanFilterCriteria.ongoing: (plan, userData) =>
      userData.plansData
          .firstWhere((element) => element.planId == plan.id)
          .currentDayIndex >
      0,
  PlanFilterCriteria.downloaded: (plan, userData) =>
      userData.id != plan.authorId,
};
