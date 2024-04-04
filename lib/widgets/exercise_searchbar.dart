import 'package:flutter/material.dart';
import 'package:gym_partner/data/exercises.dart';
import 'package:gym_partner/models/body_part.dart';
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
  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final backgroundColor = brightness == Brightness.light
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onPrimaryContainer;
    final viewBackgroundColor = brightness == Brightness.light
        ? Theme.of(context).colorScheme.onPrimary
        : Colors.grey.shade900;
    final textColor = brightness == Brightness.light
        ? Colors.grey.shade900
        : Colors.grey.shade100;
    final darkerTextColor = brightness == Brightness.light
        ? Colors.grey.shade800
        : Colors.grey.shade200;
    return SearchAnchor(
      headerTextStyle: TextStyle(color: textColor),
      viewBackgroundColor: viewBackgroundColor,
      builder: (context, controller) {
        return SearchBar(
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          controller: controller,
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.search),
          ),
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
                .map((bodyPart) => bodyPartStrings[bodyPart] ?? '')
                .join(', ');
            return ListTile(
              titleTextStyle:
                  TextStyle(color: textColor, fontWeight: FontWeight.w600),
              subtitleTextStyle: TextStyle(color: darkerTextColor),
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
