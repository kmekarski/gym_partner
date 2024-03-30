import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_partner/models/chart/chart_data_type.dart';
import 'package:gym_partner/models/chart/chart_time.dart';
import 'package:gym_partner/models/chart_data.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/models/total_stats_data.dart';
import 'package:gym_partner/models/workout_in_history.dart';
import 'package:gym_partner/providers/user_provider.dart';
import 'package:gym_partner/utils/time_format.dart';
import 'package:gym_partner/widgets/badges/custom_filter_chip.dart';
import 'package:gym_partner/widgets/chart/chart.dart';
import 'package:gym_partner/widgets/workout_in_history_row.dart';

const Map<ChartTime, String> chartTimeStrings = {
  ChartTime.lastWeek: 'Last week',
  ChartTime.thisMonth: 'This month',
  ChartTime.allTime: 'All time',
};

const Map<ChartDataType, String> chartDataTypeStrings = {
  ChartDataType.exercises: 'Exercises',
  ChartDataType.sets: 'Sets',
  ChartDataType.time: 'Time',
};

Map<ChartTime, bool Function(DateTime date)> chartTimeConditions = {
  ChartTime.lastWeek: (date) {
    final now = DateTime.now();
    final sixDaysBefore = now.subtract(const Duration(days: 6));
    return date.isAfter(DateTime(
            sixDaysBefore.year, sixDaysBefore.month, sixDaysBefore.day)) &&
        date.isBefore(now);
  },
  ChartTime.thisMonth: (date) {
    final now = DateTime.now();
    return date.month == now.month &&
        date.year == now.year &&
        date.isBefore(now);
  },
  ChartTime.allTime: (date) => date.isBefore(DateTime.now())
};

class ChartBarData {
  const ChartBarData({
    required this.value,
    required this.label,
  });

  final int value;
  final String label;
}

class WorkoutHistoryScreen extends ConsumerStatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  ConsumerState<WorkoutHistoryScreen> createState() =>
      _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends ConsumerState<WorkoutHistoryScreen> {
  ChartDataType _selectedChartDataType = ChartDataType.exercises;
  ChartTime _selectedChartTime = ChartTime.lastWeek;
  int _finishedWorkoutsCount = 0;

  Stream<DocumentSnapshot<Map<String, dynamic>>> get userDataStream {
    final userId = ref.read(userProvider).id;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }

  List<ChartBarData> mapChartData(Map<String, Map<ChartDataType, int>> data) {
    return data.entries
        .map((e) => ChartBarData(
            value: e.value[_selectedChartDataType] ?? 0, label: e.key))
        .toList();
  }

  void _selectChartDataType(ChartDataType chartDataType) {
    setState(() {
      _selectedChartDataType = chartDataType;
    });
  }

  void _selectChartTime(ChartTime chartTime) {
    setState(() {
      _selectedChartTime = chartTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutsHistory = ref.watch(userProvider).workoutsHistory;

    var filteredWorkoutsHistory = workoutsHistory
        .where((workoutInHistory) => chartTimeConditions[_selectedChartTime]!(
            workoutInHistory.timestamp.toDate()))
        .toList();

    setState(() {
      _finishedWorkoutsCount = filteredWorkoutsHistory.length;
    });

    var chartDataTypePicker = SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final chartDataType in ChartDataType.values)
            CustomFilterChip(
              text: chartDataTypeStrings[chartDataType] ?? '',
              onTap: () => _selectChartDataType(chartDataType),
              isSelected: _selectedChartDataType == chartDataType,
              hasTick: true,
            ),
        ],
      ),
    );
    var chartTimePicker = SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final chartTime in ChartTime.values)
            CustomFilterChip(
              text: chartTimeStrings[chartTime] ?? '',
              onTap: () => _selectChartTime(chartTime),
              isSelected: _selectedChartTime == chartTime,
              hasTick: true,
            ),
        ],
      ),
    );

    var streamBuilder = StreamBuilder(
      stream: userDataStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        final data = snapshot.data!.data() ?? {};
        final totalStatsData =
            TotalStatsData.fromMap(data['total_stats_data'] ?? {});
        final chartData = ChartData.fromMap(data['chart_data'] ?? {});
        List<ChartBarData> mappedChartData;

        int totalExercisesCount = 0;
        int totalSetsCount = 0;
        int totalWorkoutTime = 0;

        switch (_selectedChartTime) {
          case ChartTime.lastWeek:
            totalExercisesCount =
                totalStatsData.weekTotalStatsData[ChartDataType.exercises] ?? 0;
            totalSetsCount =
                totalStatsData.weekTotalStatsData[ChartDataType.sets] ?? 0;
            totalWorkoutTime =
                totalStatsData.weekTotalStatsData[ChartDataType.time] ?? 0;
            mappedChartData = mapChartData(chartData.weekChartData);
            break;
          case ChartTime.thisMonth:
            totalExercisesCount =
                totalStatsData.monthTotalStatsData[ChartDataType.exercises] ??
                    0;
            totalSetsCount =
                totalStatsData.monthTotalStatsData[ChartDataType.sets] ?? 0;
            totalWorkoutTime =
                totalStatsData.monthTotalStatsData[ChartDataType.time] ?? 0;
            mappedChartData = mapChartData(chartData.monthChartData);
            mappedChartData.sort(
                (a, b) => int.parse(a.label).compareTo(int.parse(b.label)));
          case ChartTime.allTime:
            totalExercisesCount =
                totalStatsData.allTimeTotalStatsData[ChartDataType.exercises] ??
                    0;
            totalSetsCount =
                totalStatsData.allTimeTotalStatsData[ChartDataType.sets] ?? 0;
            totalWorkoutTime =
                totalStatsData.allTimeTotalStatsData[ChartDataType.time] ?? 0;
            mappedChartData = mapChartData(chartData.allTimeChartData);
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  totalStat(
                    'Total exercises',
                    totalExercisesCount.toString(),
                  ),
                  totalStat(
                    'Total sets',
                    totalSetsCount.toString(),
                  ),
                  totalStat(
                    'Total time',
                    timeFormat(totalWorkoutTime),
                  ),
                ],
              ),
            ),
            const Divider(),
            if (mappedChartData.isNotEmpty)
              Column(
                children: [
                  Chart(
                    data: mappedChartData,
                    height: 240,
                    barWidth: 56,
                    chartDataType: _selectedChartDataType,
                  ),
                  const SizedBox(height: 12),
                  chartDataTypePicker,
                  const SizedBox(height: 16),
                  chartTimePicker,
                  const SizedBox(height: 8),
                ],
              ),
          ],
        );
      },
    );

    var workoutsList = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredWorkoutsHistory.length,
      itemBuilder: (context, index) =>
          WorkoutInHistoryRow(workoutInHistory: filteredWorkoutsHistory[index]),
    );

    var listTitle = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Finished workouts',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: 12),
        Stack(
          alignment: Alignment.center,
          children: [
            const CircleAvatar(
              radius: 18,
            ),
            Text(
              '$_finishedWorkoutsCount',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('My workout history'),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              streamBuilder,
              const SizedBox(height: 16),
              listTitle,
              const SizedBox(height: 16),
              workoutsList,
            ],
          )),
    );
  }

  Widget totalStat(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
