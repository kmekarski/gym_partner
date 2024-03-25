import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_partner/screens/workout_history.dart';
import 'package:gym_partner/utilities/time_format.dart';
import 'package:gym_partner/widgets/chart/chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.data,
    required this.height,
    required this.barWidth,
    required this.selectedBarIndex,
    required this.onSelectBar,
    required this.chartDataType,
  });

  final List<ChartBarData> data;
  final double height;
  final double barWidth;
  final int selectedBarIndex;
  final void Function(int) onSelectBar;
  final ChartDataType chartDataType;

  @override
  Widget build(BuildContext context) {
    int maxValue = data[0].value;
    for (final charBarData in data) {
      if (charBarData.value > maxValue) {
        maxValue = charBarData.value;
      }
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final (index, chartBarData) in data.indexed)
                  GestureDetector(
                    onTap: () => onSelectBar(index),
                    child: ChartBar(
                      width: barWidth,
                      fullHeight: height,
                      fill: chartBarData.value / maxValue,
                      topLabel: chartDataType == ChartDataType.time
                          ? timeFormat(chartBarData.value)
                          : chartBarData.value.toString(),
                      bottomLabel: chartBarData.label,
                      isSelected: selectedBarIndex == index,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
