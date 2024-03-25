import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_partner/models/plan_tag.dart';
import 'package:gym_partner/models/workout_in_history.dart';
import 'package:gym_partner/services/plans_service.dart';
import 'package:gym_partner/widgets/badges/custom_filter_chip.dart';
import 'package:gym_partner/widgets/chart/chart.dart';
import 'package:gym_partner/widgets/workout_in_history_row.dart';

enum ChartDataType {
  exercises,
  sets,
  time,
}

enum ChartTime {
  lastWeek,
  thisMonth,
  allTime,
}

const Map<ChartTime, String> chartTimeStrings = {
  ChartTime.lastWeek: 'Last week',
  ChartTime.thisMonth: 'This month',
  ChartTime.allTime: 'All time',
};

Map<ChartTime, bool Function(DateTime date)> chartTimeConditions = {
  ChartTime.lastWeek: (date) {
    final sixDaysAgo = DateTime.now().subtract(Duration(days: 6));
    return date
        .isAfter(DateTime(sixDaysAgo.year, sixDaysAgo.month, sixDaysAgo.day));
  },
  ChartTime.thisMonth: (date) {
    final now = DateTime.now();
    return date.month == now.month && date.year == now.year;
  },
  ChartTime.allTime: (date) => true,
};

const Map<ChartDataType, String> chartDataTypeStrings = {
  ChartDataType.exercises: 'Exercises',
  ChartDataType.sets: 'Sets',
  ChartDataType.time: 'Time',
};

class ChartBarData {
  const ChartBarData({
    required this.value,
    required this.label,
  });

  final int value;
  final String label;
}

class WorkoutHistoryScreen extends StatefulWidget {
  WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  ChartDataType _selectedChartDataType = ChartDataType.exercises;
  ChartTime _selectedChartTime = ChartTime.lastWeek;

  int _selectedChartBarIndex = 0;

  final List<WorkoutInHistory> workoutsHistory = [
    for (var i = 0; i < 30; i++)
      WorkoutInHistory(
        id: '${i}',
        planName: 'some plan',
        tags: [
          PlanTag.cardio,
          PlanTag.strength,
        ],
        dayIndex: 0,
        numOfSets: Random().nextInt(10) + 20,
        numOfExercises: Random().nextInt(10),
        timeInSeconds: Random().nextInt(2000) + 100,
        timestamp:
            Timestamp.fromDate(DateTime.now().subtract(Duration(days: i))),
      ),
  ];

  void _selectChartDataType(ChartDataType chartDataType) {
    setState(() {
      _selectedChartDataType = chartDataType;
      _selectedChartBarIndex = 0;
    });
  }

  void _selectChartTime(ChartTime chartTime) {
    setState(() {
      _selectedChartTime = chartTime;
    });
  }

  void _selectChartBar(int index) {
    setState(() {
      _selectedChartBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var filteredWorkoutsHistory = workoutsHistory
        .where((workoutInHistory) => chartTimeConditions[_selectedChartTime]!(
            workoutInHistory.timestamp.toDate()))
        .toList();
    var dataFromService = PlansService()
        .calculateHistoryChartData(workoutsHistory, _selectedChartTime);

    var data = dataFromService.entries
        .map((e) => ChartBarData(
            value: e.value[_selectedChartDataType] ?? 0, label: e.key))
        .toList();

    var workoutsList = Expanded(
      child: ListView.builder(
        itemCount: filteredWorkoutsHistory.length,
        itemBuilder: (context, index) => WorkoutInHistoryRow(
            workoutInHistory: filteredWorkoutsHistory[index]),
      ),
    );
    var chartDataTypePicker = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final chartDataType in ChartDataType.values)
          CustomFilterChip(
            text: chartDataTypeStrings[chartDataType] ?? '',
            onTap: () => _selectChartDataType(chartDataType),
            isSelected: _selectedChartDataType == chartDataType,
            hasTick: true,
          ),
      ],
    );
    var chartTimePicker = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final chartTime in ChartTime.values)
          CustomFilterChip(
            text: chartTimeStrings[chartTime] ?? '',
            onTap: () => _selectChartTime(chartTime),
            isSelected: _selectedChartTime == chartTime,
            hasTick: true,
          ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('My workout history'),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Chart(
              data: data,
              height: 240,
              barWidth: 56,
              selectedBarIndex: _selectedChartBarIndex,
              onSelectBar: _selectChartBar,
              chartDataType: _selectedChartDataType,
            ),
            const SizedBox(height: 16),
            chartDataTypePicker,
            const SizedBox(height: 16),
            chartTimePicker,
            const SizedBox(height: 16),
            workoutsList,
          ],
        ),
      ),
    );
  }
}
