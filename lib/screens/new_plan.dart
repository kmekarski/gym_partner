import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/exercise.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/plan_difficulty.dart';
import 'package:gym_partner/models/plan_exercise.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/models/plan_visibility.dart';
import 'package:gym_partner/providers/user_plans_provider.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/widgets/exercise_searchbar.dart';
import 'package:gym_partner/widgets/form_clickable_badge.dart';
import 'package:gym_partner/widgets/new_plan_exercise_card.dart';

class NewPlanScreen extends ConsumerStatefulWidget {
  const NewPlanScreen({super.key});

  @override
  ConsumerState<NewPlanScreen> createState() => _NewPlanModalState();
}

class _NewPlanModalState extends ConsumerState<NewPlanScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredName = '';
  bool _isSending = false;

  final List<PlanDay> _days = [
    PlanDay(id: '0'),
  ];

  int _selectedDayIndex = 0;

  final _daysListScrollController = ScrollController();

  double _daysListElementWidth = 111;
  double _daysListGapWidth = 8;
  double _plusDayButtonWidth = 50;

  List<PlanTag> _selectedTags = [];
  PlanDifficulty _selectedDifficulty = PlanDifficulty.easy;
  PlanVisibility _selectedVisibility = PlanVisibility.private;

  void _selectDay(int index) {
    setState(() {
      _selectedDayIndex = index;
    });
  }

  void _removeDay(int index) {
    if (_days.length <= 1) {
      return;
    }
    setState(() {
      _days.removeAt(index);
      _selectedDayIndex = _days.length - 1;
    });
    _animateDaysList();
  }

  void _newDay() {
    setState(() {
      _days.add(PlanDay(id: '${_days.length}'));
      _selectedDayIndex = _days.length - 1;
    });
    _animateDaysList();
  }

  void _addExercise(Exercise exercise) {
    final newPlanExercise = PlanExercise(exercise: exercise);
    setState(() {
      _days[_selectedDayIndex].exercises.add(newPlanExercise);
    });
  }

  void _removeExercise(PlanExercise exercise) {
    setState(() {
      _days[_selectedDayIndex].exercises.remove(exercise);
    });
  }

  void _animateDaysList() {
    final listWidth =
        MediaQuery.of(context).size.width - _plusDayButtonWidth - 24;
    final elementWidth = _daysListElementWidth + _daysListGapWidth;
    final numOfelementsOnScreen = (listWidth / elementWidth).floor();
    print(numOfelementsOnScreen);
    final needsToScroll = _days.length > numOfelementsOnScreen;
    _daysListScrollController.animateTo(
        needsToScroll
            ? (_days.length - numOfelementsOnScreen - 1) * elementWidth + 24
            : 0,
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

  void _toggleTag(PlanTag tag) {
    if (_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.remove(tag);
      });
    } else {
      setState(() {
        _selectedTags.add(tag);
      });
    }
  }

  void _selectDifficulty(PlanDifficulty difficulty) {
    setState(() {
      _selectedDifficulty = difficulty;
    });
  }

  void _selectVisibility(PlanVisibility visibility) {
    setState(() {
      _selectedVisibility = visibility;
    });
  }

  void _submitPlanData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isSending = true;
    });

    final newPlan = Plan(
        id: '',
        name: _enteredName,
        days: _days,
        tags: _selectedTags,
        difficulty: _selectedDifficulty,
        visibility: _selectedVisibility,
        authorName: '');

    final addedPlan =
        await ref.read(userPlansProvider.notifier).addNewPlan(newPlan);

    await ref.read(userProvider.notifier).addNewPlanData(addedPlan!.id);

    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagSelectedBackgroundColor = Theme.of(context).colorScheme.primary;
    final tagUnselectedBackgroundColor =
        Theme.of(context).colorScheme.secondaryContainer;
    final tagSelectedTextColor = Colors.white;
    final tagUnselectedTextColor = Colors.black87;
    var daysPicker = SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: ListView(
              controller: _daysListScrollController,
              scrollDirection: Axis.horizontal,
              children: [
                for (var (index, day) in _days.indexed)
                  FormBadge.withX(
                    text: 'Day ${index + 1}',
                    width: _daysListElementWidth,
                    isSelected: index == _selectedDayIndex,
                    onTap: () {
                      _selectDay(index);
                    },
                    onXTap: () => _removeDay(index),
                    selectedBackgroundColor: tagSelectedBackgroundColor,
                    unselectedBackgroundColor: tagUnselectedBackgroundColor,
                    selectedTextColor: tagSelectedTextColor,
                    unselectedTextColor: tagUnselectedTextColor,
                    margin: EdgeInsets.only(right: _daysListGapWidth),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: _plusDayButtonWidth,
            child: Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: _newDay,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    var exercisesPicker = Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ExerciseSearchbar(
                  hintText: _days[_selectedDayIndex].exercises.isEmpty
                      ? 'Search for exercise...'
                      : 'Add another exercise...',
                  onSelect: _addExercise),
              const SizedBox(height: 16),
              if (_days[_selectedDayIndex].exercises.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '...or make it a rest day!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              if (_days[_selectedDayIndex].exercises.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: _days[_selectedDayIndex].exercises.length,
                    itemBuilder: (context, index) => NewPlanExerciseCard(
                      exercise: _days[_selectedDayIndex].exercises[index],
                      index: index,
                      onNumberOfSetsChanged: (value) => setState(() {
                        _days[_selectedDayIndex].exercises[index].numOfSets =
                            value;
                      }),
                      onNumberOfRepsChanged: (value) => setState(() {
                        _days[_selectedDayIndex].exercises[index].numOfReps =
                            value;
                      }),
                      onRestTimeChanged: (value) => setState(() {
                        _days[_selectedDayIndex].exercises[index].restTime =
                            value;
                      }),
                      onXTap: _removeExercise,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    var tagsPicker = Row(
      children: [
        sectionTitle('Tags:'),
        Row(
          children: [
            for (final tag in PlanTag.values)
              FormBadge(
                text: tag.toString().split('.').last,
                isSelected: _selectedTags.contains(tag),
                onTap: () => _toggleTag(tag),
                selectedBackgroundColor: tagSelectedBackgroundColor,
                unselectedBackgroundColor: tagUnselectedBackgroundColor,
                selectedTextColor: tagSelectedTextColor,
                unselectedTextColor: tagUnselectedTextColor,
              )
          ],
        ),
      ],
    );

    var difficultyPicker = SizedBox(
      height: 42,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          sectionTitle('Difficulty:'),
          Row(
            children: [
              for (final difficulty in PlanDifficulty.values)
                FormBadge(
                  text: difficulty.toString().split('.').last,
                  isSelected: _selectedDifficulty == difficulty,
                  onTap: () => _selectDifficulty(difficulty),
                  selectedBackgroundColor: tagSelectedBackgroundColor,
                  unselectedBackgroundColor: tagUnselectedBackgroundColor,
                  selectedTextColor: tagSelectedTextColor,
                  unselectedTextColor: tagUnselectedTextColor,
                ),
            ],
          ),
        ],
      ),
    );

    var visibilityPicker = Row(
      children: [
        sectionTitle('Visibility:'),
        Row(
          children: [
            for (final visibility in PlanVisibility.values)
              FormBadge(
                text: visibility.toString().split('.').last,
                isSelected: _selectedVisibility == visibility,
                onTap: () => _selectVisibility(visibility),
                selectedBackgroundColor: tagSelectedBackgroundColor,
                unselectedBackgroundColor: tagUnselectedBackgroundColor,
                selectedTextColor: tagSelectedTextColor,
                unselectedTextColor: tagUnselectedTextColor,
              )
          ],
        ),
      ],
    );

    var createButton = SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white),
        onPressed: _submitPlanData,
        icon: _isSending ? const Icon(null) : const Icon(Icons.add),
        label: _isSending
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : const Text(
                'Create plan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
    var nameTextFormField = TextFormField(
      onSaved: (newValue) {
        _enteredName = newValue!;
      },
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            value.trim().length <= 1 ||
            value.trim().length > 50) {
          return 'Must be between 1 and 50 characters.';
        } else {
          return null;
        }
      },
      maxLength: 50,
      decoration: const InputDecoration(
        label: Text('Enter plan name'),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create workout plan',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 24, left: 24, bottom: 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle('Name:'),
              nameTextFormField,
              const SizedBox(height: 12),
              visibilityPicker,
              const SizedBox(height: 24),
              daysPicker,
              const SizedBox(height: 16),
              exercisesPicker,
              const SizedBox(height: 24),
              tagsPicker,
              const SizedBox(height: 24),
              difficultyPicker,
              const SizedBox(height: 36),
              createButton,
            ],
          ),
        ),
      ),
    );
  }
}
