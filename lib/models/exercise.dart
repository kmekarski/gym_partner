import 'package:gym_partner/models/body_part.dart';

class Exercise {
  const Exercise({
    required this.name,
    required this.bodyParts,
  });

  final String name;
  final List<BodyPart> bodyParts;
}
