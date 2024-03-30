import 'package:gym_partner/models/chart/chart_data_type.dart';
import 'package:gym_partner/utils/day_of_week_mappers.dart';

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

    DateTime now = DateTime.now();
    String currentDay = getDayOfWeekString(now.weekday);

    List<MapEntry<String, Map<ChartDataType, int>>> sortedEntries =
        weekChartData.entries.toList()
          ..sort((a, b) {
            int aIndex = getDayOfWeekIndex(a.key);
            int bIndex = getDayOfWeekIndex(b.key);
            int currentDayIndex = getDayOfWeekIndex(currentDay);

            if (currentDayIndex - bIndex < 0) {
              bIndex -= 7;
            }

            if (currentDayIndex - aIndex < 0) {
              aIndex -= 7;
            }

            return (currentDayIndex - bIndex)
                .compareTo(currentDayIndex - aIndex);
          });

    return ChartData(
      weekChartData: Map.fromEntries(sortedEntries),
      monthChartData: monthChartData,
      allTimeChartData: allTimeChartData,
    );
  }

  final Map<String, Map<ChartDataType, int>> weekChartData;
  final Map<String, Map<ChartDataType, int>> monthChartData;
  final Map<String, Map<ChartDataType, int>> allTimeChartData;
}
