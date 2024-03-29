import 'package:gym_partner/models/chart/chart_data_type.dart';

class ChartData {
  const ChartData({
    required this.weekChartData,
    required this.monthChartData,
    required this.allTimeChartData,
  });

  factory ChartData.fromMap(Map<String, dynamic> data) {
    Map<String, dynamic> lastWeekDataData = data['last_week'] ?? {};
    Map<String, dynamic> thisMonthDataData = data['this_month'] ?? {};
    Map<String, dynamic> allTimeDataData = data['all_time'] ?? {};

    final Map<String, Map<ChartDataType, int>> weekChartData = {};
    final Map<String, Map<ChartDataType, int>> monthChartData = {};
    final Map<String, Map<ChartDataType, int>> allTimeChartData = {};

    for (final entry in lastWeekDataData.entries) {
      weekChartData[entry.key] = {
        ChartDataType.exercises: entry.value['exercises'] ?? 0,
        ChartDataType.sets: entry.value['sets'] ?? 0,
        ChartDataType.time: entry.value['time'] ?? 0,
      };
    }

    for (final entry in thisMonthDataData.entries) {
      monthChartData[entry.key] = {
        ChartDataType.exercises: entry.value['exercises'] ?? 0,
        ChartDataType.sets: entry.value['sets'] ?? 0,
        ChartDataType.time: entry.value['time'] ?? 0,
      };
    }

    for (final entry in allTimeDataData.entries) {
      allTimeChartData[entry.key] = {
        ChartDataType.exercises: entry.value['exercises'] ?? 0,
        ChartDataType.sets: entry.value['sets'] ?? 0,
        ChartDataType.time: entry.value['time'] ?? 0,
      };
    }

    return ChartData(
      weekChartData: weekChartData,
      monthChartData: monthChartData,
      allTimeChartData: allTimeChartData,
    );
  }

  final Map<String, Map<ChartDataType, int>> weekChartData;
  final Map<String, Map<ChartDataType, int>> monthChartData;
  final Map<String, Map<ChartDataType, int>> allTimeChartData;
}
