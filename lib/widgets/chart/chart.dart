import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_partner/models/chart/chart_data_type.dart';
import 'package:gym_partner/screens/workout_history.dart';
import 'package:gym_partner/utils/time_format.dart';
import 'package:gym_partner/widgets/chart/chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.data,
    required this.height,
    required this.barWidth,
    required this.chartDataType,
  });

  final List<ChartBarData> data;
  final double height;
  final double barWidth;
  final ChartDataType chartDataType;

  double get topLabelFontSize {
    if (chartDataType == ChartDataType.time) {
      return 12;
    } else {
      return 16;
    }
  }

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
                  ChartBar(
                    width: barWidth,
                    fullHeight: height,
                    fill: chartBarData.value / maxValue,
                    topLabel: chartDataType == ChartDataType.time
                        ? timeFormat(chartBarData.value)
                        : chartBarData.value.toString(),
                    bottomLabel: chartBarData.label,
                    topLabelFontSize: topLabelFontSize,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
