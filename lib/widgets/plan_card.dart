import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gym_partner/models/plan.dart';
import 'package:gym_partner/models/plan_difficulty.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/models/user_plan_data.dart';
import 'package:gym_partner/services/users_service.dart';
import 'package:gym_partner/widgets/badges/circle_icon.dart';
import 'package:gym_partner/widgets/circle_user_avatar.dart';
import 'package:gym_partner/widgets/plans_list.dart';
import 'package:gym_partner/widgets/badges/simple_badge.dart';

class PlanCard extends StatefulWidget {
  const PlanCard({
    super.key,
    required this.type,
    this.planData,
    required this.plan,
    required this.onSelectPlan,
  });

  final PlansListType type;
  final Plan plan;
  final UserPlanData? planData;
  final void Function(Plan plan) onSelectPlan;

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final badgesBackgroundColor = brightness == Brightness.light
        ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
        : Theme.of(context).colorScheme.primaryContainer;
    final bagdesForegroundColor =
        Theme.of(context).colorScheme.onPrimaryContainer;
    final progressCircleBackgroundColor = brightness == Brightness.light
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7);

    var numOfDaysIndicator = Row(
      children: [
        const CircleIcon(iconData: Icons.calendar_month),
        const SizedBox(width: 6),
        Text(
          '${widget.plan.days.length}',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: badgesBackgroundColor,
              ),
        ),
      ],
    );

    var difficultyBadge = SimpleBadge(
      text: planDifficultyStrings[widget.plan.difficulty] ?? '',
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
    );

    var isRecentBadge = SimpleBadge(
      text: 'Recent workout',
      backgroundColor: badgesBackgroundColor,
      textColor: bagdesForegroundColor,
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

    var progressCircle = widget.planData != null
        ? Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: widget.planData!.currentDayIndex /
                        widget.plan.days.length,
                    strokeWidth: 6,
                    backgroundColor: progressCircleBackgroundColor,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  '${widget.plan.getCompletionPercentage(widget.planData!.currentDayIndex)}%',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        : null;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          widget.onSelectPlan(widget.plan);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 124,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.plan.name,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 26,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        tags,
                      ],
                    ),
                    if (widget.planData != null) progressCircle!,
                    if (widget.planData == null)
                      Row(
                        children: [
                          CircleUserAvatar(
                              avatarUrl: widget.plan.authorAvatarUrl),
                          const SizedBox(width: 6),
                          Text(
                            widget.plan.authorName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    difficultyBadge,
                    if (widget.planData != null && widget.planData!.isRecent)
                      Row(
                        children: [
                          const SizedBox(width: 6),
                          isRecentBadge,
                        ],
                      ),
                    const Spacer(),
                    numOfDaysIndicator,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
