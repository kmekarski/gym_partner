import 'package:flutter/material.dart';
import 'package:gym_partner/models/plan_difficulty.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/widgets/badges/custom_filter_chip.dart';

enum PlanFilterCriteria {
  tags,
  difficulty,
}

class SharedPlansFilters extends StatefulWidget {
  const SharedPlansFilters({
    super.key,
    required this.tags,
    required this.difficulty,
  });

  final List<PlanTag> tags;
  final PlanDifficulty? difficulty;

  @override
  State<SharedPlansFilters> createState() => _SharedPlansFiltersState();
}

class _SharedPlansFiltersState extends State<SharedPlansFilters> {
  List<PlanTag> _selectedTags = [];
  PlanDifficulty? _selectedDifficulty;

  @override
  void initState() {
    _selectedTags = widget.tags;
    _selectedDifficulty = widget.difficulty;
    super.initState();
  }

  void _toggleTag(PlanTag tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _selectDifficulty(PlanDifficulty difficulty) {
    setState(() {
      if (_selectedDifficulty == difficulty) {
        _selectedDifficulty = null;
      } else {
        _selectedDifficulty = difficulty;
      }
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedDifficulty = null;
      _selectedTags.clear();
    });
  }

  void _applyFilters() {
    Navigator.of(context).pop<Map<PlanFilterCriteria, dynamic>>({
      PlanFilterCriteria.difficulty: _selectedDifficulty,
      PlanFilterCriteria.tags: _selectedTags,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 44,
            child: Row(
              children: [
                Text(
                  'Tags:',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final tag in PlanTag.values)
                        CustomFilterChip(
                          text: planTagStrings[tag] ?? '',
                          onTap: () => _toggleTag(tag),
                          isSelected: _selectedTags.contains(tag),
                          hasTick: true,
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: Row(
              children: [
                Text(
                  'Difficulty:',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final difficulty in PlanDifficulty.values)
                        CustomFilterChip(
                          text: planDifficultyStrings[difficulty] ?? '',
                          onTap: () => _selectDifficulty(difficulty),
                          isSelected: _selectedDifficulty == difficulty,
                          hasTick: true,
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _resetFilters,
                child: const Text('Reset'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyFilters,
                child: const Text('Apply filters'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
