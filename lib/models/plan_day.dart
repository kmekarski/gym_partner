class PlanDay {
  PlanDay({required this.id});
  final String id;

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
    };
  }
}
