import 'package:gym_partner/services/history_service.dart';

class ChartData {
  const ChartData({
    required this.weekChartData,
    required this.monthChartData,
    required this.allTimeChartData,
  });
  final Map<String, Map<ChartDataType, int>> weekChartData;
  final Map<String, Map<ChartDataType, int>> monthChartData;
  final Map<String, Map<ChartDataType, int>> allTimeChartData;
}
