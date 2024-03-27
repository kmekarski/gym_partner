import 'package:gym_partner/screens/workout_history.dart';
import 'package:gym_partner/services/history_service.dart';

class TotalStatsData {
  const TotalStatsData({
    required this.weekTotalStatsData,
    required this.monthTotalStatsData,
    required this.allTimeTotalStatsData,
  });

  final Map<ChartDataType, int> weekTotalStatsData;
  final Map<ChartDataType, int> monthTotalStatsData;
  final Map<ChartDataType, int> allTimeTotalStatsData;
}
