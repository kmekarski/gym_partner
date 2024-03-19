import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/plan_tag.dart';

class Plan {
  Plan({
    required this.id,
    required this.name,
    required this.days,
    required this.tags,
    required this.authorName,
  });

  factory Plan.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    List<dynamic> daysData = data['days'] ?? [];
    List<PlanDay> days = daysData.map((dayData) {
      return PlanDay(id: dayData['id'] ?? '');
    }).toList();

    List<dynamic> tagsData = data['tags'] ?? [];
    List<PlanTag> tags = tagsData.map((tagString) {
      return PlanTag.values.firstWhere((e) => e.toString() == tagString,
          orElse: () => PlanTag.cardio);
    }).toList();
    return Plan(
      id: doc.id,
      name: data['name'] ?? '',
      days: days,
      tags: tags,
      authorName: data['author_name'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'days': days.map((day) => day.toFirestore()).toList(),
      'tags': tags.map((tag) => tag.toString()).toList(),
      'author_name': authorName,
    };
  }

  final String id;
  final String name;
  final List<PlanDay> days;
  final List<PlanTag> tags;
  final String authorName;
}
