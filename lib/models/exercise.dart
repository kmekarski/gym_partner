import 'package:gym_partner/models/body_part.dart';

class Exercise {
  const Exercise({
    required this.name,
    required this.description,
    required this.bodyParts,
  });

  final String name;
  final String description;
  final List<BodyPart> bodyParts;
}
