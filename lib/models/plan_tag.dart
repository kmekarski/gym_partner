import 'package:gym_partner/models/plan.dart';

enum PlanTag {
  cardio,
  strength,
  yoga,
}

Map<PlanTag, String> planTagStrings = {
  PlanTag.cardio: 'Cardio',
  PlanTag.strength: 'Strength',
  PlanTag.yoga: 'Yoga',
};
