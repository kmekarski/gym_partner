import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/body_part.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_day.dart';
import 'package:gym_partner/models/plan_difficulty.dart';
import 'package:gym_partner/models/plan_exercise.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/providers/user_plans_provider.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/screens/workout.dart';
import 'package:gym_partner/utils/scaffold_messeger_utils.dart';
import 'package:gym_partner/widgets/buttons/wide_button.dart';
import 'package:gym_partner/widgets/circle_user_avatar.dart';
import 'package:gym_partner/widgets/modals/delete_plan_confirmation.dart';
import 'package:gym_partner/widgets/plan_day_card.dart';
import 'package:gym_partner/widgets/plans_list.dart';
import 'package:gym_partner/widgets/badges/simple_badge.dart';
import 'package:gym_partner/widgets/small_circle_progress_indicator.dart';

class PlanDetailsScreen extends ConsumerStatefulWidget {
  const PlanDetailsScreen({super.key, required this.type, required this.plan});

  final PlansListType type;
  final Plan plan;

  @override
  ConsumerState<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends ConsumerState<PlanDetailsScreen> {
  bool _isWaiting = false;

  void _downloadPlan() async {
    setState(() {
      _isWaiting = true;
    });
    final downloadedPlan =
        await ref.read(userPlansProvider.notifier).downloadPlan(widget.plan);
    if (downloadedPlan != null) {
      await ref.read(userProvider.notifier).addNewPlanData(downloadedPlan!.id);
    }
    Navigator.of(context).pop();
    showSnackBar(
        context, 'Workout plan ${widget.plan.name} added to your plans');
  }

  void _deletePlan() async {
    await ref.read(userPlansProvider.notifier).deletePlan(widget.plan);
    await ref.read(userProvider.notifier).deletePlanData(widget.plan.id);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    showSnackBar(context, 'Workout plan ${widget.plan.name} deleted');
  }

  void _showDeleteModal() {
    showDialog(
        context: context,
        builder: (context) => DeletePlanConfirmationModal(
              onDelete: _deletePlan,
            ));
  }

  void _startWorkout(PlanDay day) async {
    if (widget.type == PlansListType.private) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => WorkoutScreen(
          day: day,
          plan: widget.plan,
        ),
      ));
      ref.read(userProvider.notifier).setPlanAsRecent(widget.plan.id);
    }
    if (widget.type == PlansListType.public) {}
  }

  @override
  Widget build(BuildContext context) {
    final planData = widget.type == PlansListType.private
        ? ref
            .read(userProvider)
            .plansData
            .firstWhere((planData) => planData.planId == widget.plan.id)
        : null;
    var authorInfo = Row(
      children: [
        CircleUserAvatar(avatarUrl: widget.plan.authorAvatarUrl, radius: 24),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Created by',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              widget.plan.authorName,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        )
      ],
    );

    var tags = Row(
      children: [
        for (PlanTag tag in widget.plan.tags)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              planTagStrings[tag] ?? '',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
      ],
    );

    var badges = SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SimpleBadge(
              text: planDifficultyStrings[widget.plan.difficulty] ?? '',
              textColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          for (final tag in widget.plan.tags)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SimpleBadge(
                  text: planTagStrings[tag] ?? '',
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary),
            ),
        ],
      ),
    );

    var todaysActivitySection = widget.type == PlansListType.private
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Today\'s activity', context),
              _planDayCard(widget.plan.days[planData!.currentDayIndex],
                  planData!.currentDayIndex, context),
              const SizedBox(height: 16),
              _sectionTitle('Whole plan', context),
            ],
          )
        : null;

    var daysList = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.plan.days.length,
      itemBuilder: (context, index) =>
          _planDayCard(widget.plan.days[index], index, context),
    );

    var bottomButton = WideButton(
      text: widget.type == PlansListType.private
          ? 'Start workout'
          : _isWaiting
              ? null
              : 'Add to your plans',
      label: _isWaiting ? const SmallCircleProgressIndicator() : null,
      icon: null,
      onPressed: () => widget.type == PlansListType.private
          ? _startWorkout(widget.plan.days[planData!.currentDayIndex])
          : _downloadPlan(),
    );
    var appBar = AppBar(
      title: Text(widget.plan.name),
      actions: [
        if (widget.type == PlansListType.private)
          IconButton(
              onPressed: _showDeleteModal, icon: const Icon(Icons.delete)),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 12, right: 16, left: 16, bottom: 32),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    authorInfo,
                    const SizedBox(height: 16),
                    badges,
                    const SizedBox(height: 16),
                    if (widget.type == PlansListType.private)
                      todaysActivitySection!,
                    daysList,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            bottomButton,
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _planDayCard(PlanDay day, int dayIndex, BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Day ${dayIndex + 1}',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (day.exercises.isEmpty)
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rest day',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            for (final (index, exercise) in day.exercises.indexed)
              PlanExerciseRow(
                exercise: exercise,
                index: index,
                dividerColor: brightness == Brightness.light
                    ? null
                    : Theme.of(context).colorScheme.primary,
              )
          ],
        ),
      ),
    );
  }
}
