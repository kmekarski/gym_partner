import 'package:gym_partner/models/body_part.dart';
import 'package:gym_partner/models/exercise.dart';

const List<Exercise> allExercises = [
  Exercise(
    name: 'Squat',
    bodyParts: [
      BodyPart.legs,
      BodyPart.quads,
      BodyPart.glutes,
    ],
  ),
  Exercise(
    name: 'Bench press',
    bodyParts: [
      BodyPart.chest,
      BodyPart.tricep,
    ],
  ),
  Exercise(
    name: 'Shoulder press',
    bodyParts: [
      BodyPart.shoulders,
    ],
  ),
];
