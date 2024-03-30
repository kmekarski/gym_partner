import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_partner/models/chart/chart_data_type.dart';
import 'package:gym_partner/screens/workout_history.dart';

class TotalStatsData {
  const TotalStatsData({
    this.weekTotalStatsData = const {},
    this.monthTotalStatsData = const {},
    this.allTimeTotalStatsData = const {},
  });

  factory TotalStatsData.fromMap(Map<String, dynamic> data) {
    Map<String, dynamic> lastWeekDataData = data['last_week'] ?? {};
    Map<String, dynamic> thisMonthDataData = data['this_month'] ?? {};
    Map<String, dynamic> allTimeDataData = data['all_time'] ?? {};

    final Map<ChartDataType, int> weekTotalStatsData = {
      ChartDataType.exercises: lastWeekDataData['exercises'] ?? 0,
      ChartDataType.sets: lastWeekDataData['sets'] ?? 0,
      ChartDataType.time: lastWeekDataData['time'] ?? 0,
    };
    final Map<ChartDataType, int> monthTotalStatsData = {
      ChartDataType.exercises: thisMonthDataData['exercises'] ?? 0,
      ChartDataType.sets: thisMonthDataData['sets'] ?? 0,
      ChartDataType.time: thisMonthDataData['time'] ?? 0,
    };
    final Map<ChartDataType, int> allTimeTotalStatsData = {
      ChartDataType.exercises: allTimeDataData['exercises'] ?? 0,
      ChartDataType.sets: allTimeDataData['sets'] ?? 0,
      ChartDataType.time: allTimeDataData['time'] ?? 0,
    };

    return TotalStatsData(
      weekTotalStatsData: weekTotalStatsData,
      monthTotalStatsData: monthTotalStatsData,
      allTimeTotalStatsData: allTimeTotalStatsData,
    );
  }

  final Map<ChartDataType, int> weekTotalStatsData;
  final Map<ChartDataType, int> monthTotalStatsData;
  final Map<ChartDataType, int> allTimeTotalStatsData;
}
