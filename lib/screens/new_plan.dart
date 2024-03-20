import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/plan_difficulty.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/providers/user_plans_provider.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/widgets/form_clickable_badge.dart';

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

  int? _selectedDayIndex = 0;

  final _daysListScrollController = ScrollController();

  double _daysListElementWidth = 111;
  double _daysListGapWidth = 8;
  double _plusDayButtonWidth = 50;

  List<PlanTag> _selectedTags = [];
  PlanDifficulty _selectedDifficulty = PlanDifficulty.beginner;

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

  void _animateDaysList() {
    final listWidth = MediaQuery.of(context).size.width - _plusDayButtonWidth;
    final elementWidth = _daysListElementWidth + _daysListGapWidth;
    final numOfelementsOnScreen = (listWidth / elementWidth).floor();
    print(numOfelementsOnScreen);
    final needsToScroll = _days.length > numOfelementsOnScreen;
    _daysListScrollController.animateTo(
        needsToScroll
            ? (_days.length - numOfelementsOnScreen) * elementWidth
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
        authorName: '');

    final addedPlan =
        await ref.read(userPlansProvider.notifier).addNewPlan(newPlan);

    await ref.read(userProvider.notifier).addNewPlanData(addedPlan!.id);

    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
                for (var (index, day) in _days.indexed) dayButton(day, index),
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
    var exercisesPicker = const Expanded(
      child: Center(
        child: Text('Lets add'),
      ),
    );
    final tagSelectedBackgroundColor =
        Theme.of(context).colorScheme.primaryContainer;
    final tagUnselectedBackgroundColor =
        Theme.of(context).colorScheme.secondaryContainer;
    var tagsPicker = Row(
      children: [
        const Text('Tags'),
        const SizedBox(width: 16),
        Row(
          children: [
            for (final tag in PlanTag.values)
              FormBadge(
                  text: tag.toString().split('.').last,
                  isSelected: _selectedTags.contains(tag),
                  onTap: () => _toggleTag(tag),
                  selectedBackgroundColor: tagSelectedBackgroundColor,
                  unselectedBackgroundColor: tagUnselectedBackgroundColor)
          ],
        ),
      ],
    );

    var difficultyPicker = Row(
      children: [
        const Text('Difficulty'),
        const SizedBox(width: 16),
        Row(
          children: [
            for (final difficulty in PlanDifficulty.values)
              FormBadge(
                  text: difficulty.toString().split('.').last,
                  isSelected: _selectedDifficulty == difficulty,
                  onTap: () => _selectDifficulty(difficulty),
                  selectedBackgroundColor: tagSelectedBackgroundColor,
                  unselectedBackgroundColor: tagUnselectedBackgroundColor)
          ],
        ),
      ],
    );

    var bottomButtons = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: _submitPlanData,
          child: _isSending
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(),
                )
              : const Text('Save'),
        ),
      ],
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
        title: const Text('Create workout plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, bottom: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              nameTextFormField,
              daysPicker,
              exercisesPicker,
              tagsPicker,
              const SizedBox(height: 24),
              difficultyPicker,
              const SizedBox(height: 24),
              bottomButtons,
            ],
          ),
        ),
      ),
    );
  }

  Widget dayButton(PlanDay day, int index) {
    return Padding(
      padding: EdgeInsets.only(right: _daysListGapWidth),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          _selectDay(index);
        },
        child: Container(
          width: _daysListElementWidth,
          padding: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Row(
            children: [
              Text(
                'Day ${index + 1}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color:
                        index == _selectedDayIndex ? Colors.black : Colors.grey,
                    fontSize: 14),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _removeDay(index),
                icon: const Icon(Icons.close),
                iconSize: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
