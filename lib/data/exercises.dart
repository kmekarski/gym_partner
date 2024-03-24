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
    description:
        'Keep your feet shoulder-width apart, chest up, and back straight. Lower your body as if sitting back into a chair, ensuring your knees stay in line with your toes. Push through your heels to return to the starting position.',
  ),
  Exercise(
    name: 'Bench press',
    bodyParts: [
      BodyPart.chest,
      BodyPart.tricep,
    ],
    description:
        'Lie on a flat bench with your feet firmly planted on the ground. Grip the barbell slightly wider than shoulder-width apart. Lower the barbell to your chest in a controlled manner, then press it back up to the starting position, keeping your elbows tucked in.',
  ),
  Exercise(
    name: 'Shoulder press',
    bodyParts: [
      BodyPart.shoulders,
    ],
    description:
        'Sit or stand with a dumbbell in each hand at shoulder height. Press the dumbbells upward until your arms are fully extended overhead, then lower them back down to shoulder height. Keep your core engaged and avoid arching your back.',
  ),
  Exercise(
    name: 'Deadlift',
    bodyParts: [
      BodyPart.back,
      BodyPart.hamstrings,
      BodyPart.glutes,
    ],
    description:
        'Stand with your feet hip-width apart, toes under the bar. Hinge at the hips and bend your knees to grip the barbell. Keep your back flat as you lift the barbell by straightening your hips and knees. Stand tall at the top, then lower the barbell back down with control.',
  ),
  Exercise(
    name: 'Pull-up',
    bodyParts: [
      BodyPart.back,
      BodyPart.bicep,
    ],
    description:
        'Hang from a pull-up bar with your hands slightly wider than shoulder-width apart, palms facing away. Pull yourself up until your chin passes the bar, then lower yourself back down with control. Keep your core engaged and avoid swinging.',
  ),
  Exercise(
    name: 'Push-up',
    bodyParts: [
      BodyPart.chest,
      BodyPart.shoulders,
      BodyPart.tricep,
    ],
    description:
        'Start in a plank position with your hands slightly wider than shoulder-width apart. Lower your body until your chest nearly touches the ground, then push yourself back up to the starting position. Keep your core engaged and maintain a straight line from head to heels.',
  ),
  Exercise(
    name: 'Barbell row',
    bodyParts: [
      BodyPart.back,
      BodyPart.bicep,
    ],
    description:
        'Stand with your feet shoulder-width apart, knees slightly bent, and grip a barbell with your hands slightly wider than shoulder-width apart. Keeping your back flat, hinge at the hips and bend your knees slightly. Pull the barbell toward your lower chest, then lower it back down with control.',
  ),
  Exercise(
    name: 'Lunges',
    bodyParts: [
      BodyPart.legs,
      BodyPart.glutes,
      BodyPart.quads,
    ],
    description:
        'Stand tall with your feet hip-width apart. Take a big step forward with one leg, lowering your body until both knees are bent at a 90-degree angle. Push back up to the starting position and repeat on the other leg. Keep your chest up and core engaged throughout the movement.',
  ),
  Exercise(
    name: 'Russian twist',
    bodyParts: [
      BodyPart.core,
    ],
    description:
        'Sit on the floor with your knees bent and feet elevated off the ground. Hold a weight or medicine ball with both hands in front of your chest. Lean back slightly and twist your torso to the right, then to the left, while keeping your core engaged. Control the movement with your obliques.',
  ),
  Exercise(
    name: 'Plank',
    bodyParts: [
      BodyPart.core,
    ],
    description:
        'Start in a push-up position with your elbows directly beneath your shoulders and your body forming a straight line from head to heels. Hold this position, keeping your core engaged and avoiding any sagging or arching in your back.',
  ),
  Exercise(
    name: 'Dumbbell curl',
    bodyParts: [
      BodyPart.bicep,
    ],
    description:
        'Stand with a dumbbell in each hand, arms fully extended by your sides and palms facing forward. Keeping your elbows close to your sides, curl the dumbbells upward toward your shoulders, then lower them back down with control. Avoid swinging your body or using momentum.',
  ),
  Exercise(
    name: 'Tricep dip',
    bodyParts: [
      BodyPart.tricep,
    ],
    description:
        'Sit on a bench or chair with your hands gripping the edge, fingers pointing forward. Extend your legs out in front of you and scoot your hips off the edge of the bench. Lower your body by bending your elbows until they reach a 90-degree angle, then press back up to the starting position.',
  ),
  Exercise(
    name: 'Leg press',
    bodyParts: [
      BodyPart.legs,
      BodyPart.glutes,
    ],
    description:
        'Sit on the leg press machine with your back flat against the backrest and feet shoulder-width apart on the platform. Unhook the safety bars and slowly lower the platform until your knees are bent at a 90-degree angle. Push the platform back up to the starting position, fully extending your legs.',
  ),
  Exercise(
    name: 'Hamstring curl',
    bodyParts: [
      BodyPart.hamstrings,
    ],
    description:
        'Lie face down on a leg curl machine with your heels hooked under the padded lever and your legs fully extended. Flex your knees to curl the lever upward as far as possible, then lower it back down with control. Keep your hips pressed into the bench throughout the movement.',
  ),
];
