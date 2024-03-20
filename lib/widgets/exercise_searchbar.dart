import 'package:flutter/material.dart';
import 'package:gym_partner/data/exercises.dart';
import 'package:gym_partner/models/exercise.dart';

class ExerciseSearchbar extends StatefulWidget {
  const ExerciseSearchbar(
      {super.key, required this.hintText, required this.onSelect});

  final String hintText;
  final void Function(Exercise exercise) onSelect;
  @override
  State<ExerciseSearchbar> createState() => _ExerciseSearchbarState();
}

class _ExerciseSearchbarState extends State<ExerciseSearchbar> {
  final _searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          leading: Icon(Icons.search),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          hintText: widget.hintText,
        );
      },
      suggestionsBuilder: (context, controller) {
        return allExercises.map(
          (exercise) {
            final bodyPartsString = exercise.bodyParts
                .map((bodyPart) => bodyPart.toString().split('.').last)
                .join(', ');
            return ListTile(
              title: Text(exercise.name),
              subtitle: Text(bodyPartsString),
              onTap: () {
                widget.onSelect(exercise);
                setState(() {
                  controller.closeView('');
                });
              },
            );
          },
        );
      },
    );
  }
}
