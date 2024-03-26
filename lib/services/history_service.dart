import 'dart:collection';
import 'package:gym_partner/models/workout_in_history.dart';
import 'package:jiffy/jiffy.dart';

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

class HistoryService {
  Map<ChartDataType, int> calculateTotalStats(
    List<WorkoutInHistory> workoutsHistory,
    ChartTime chartTime,
  ) {
    print('calculating total stats');

    final Map<ChartDataType, int> totalStats = {};

    int totalExercisesCount = 0;
    int totalSetsCount = 0;
    int totalTime = 0;

    for (var workout in workoutsHistory) {
      final workoutDate = workout.timestamp.toDate();
      if (chartTimeConditions[chartTime]!(workoutDate)) {
        totalExercisesCount += workout.numOfExercises;
        totalSetsCount += workout.numOfSets;
        totalTime += workout.timeInSeconds;
      }
    }
    return {
      ChartDataType.exercises: totalExercisesCount,
      ChartDataType.sets: totalSetsCount,
      ChartDataType.time: totalTime,
    };
  }

  Map<String, Map<ChartDataType, int>> calculateHistoryChartData(
    List<WorkoutInHistory> workoutsHistory,
    ChartTime chartTime,
  ) {
    print('calculating chart data');

    final now = Jiffy.now();
    final sixDaysBefore = now.subtract(days: 6);
    Jiffy intervalStart = Jiffy.parseFromDateTime(
        DateTime(sixDaysBefore.year, sixDaysBefore.month, sixDaysBefore.date));
    Jiffy intervalEnd = now;

    if (chartTime == ChartTime.thisMonth) {
      intervalStart = Jiffy.parseFromDateTime(DateTime(now.year, now.month));
    }

    if (chartTime == ChartTime.allTime) {
      Jiffy firstWorkoutDate =
          Jiffy.parseFromDateTime(workoutsHistory.first.timestamp.toDate());
      for (final workout in workoutsHistory) {
        final workoutDate = Jiffy.parseFromDateTime(workout.timestamp.toDate());
        if (workoutDate.isBefore(firstWorkoutDate)) {
          firstWorkoutDate = workoutDate;
        }
      }
      intervalStart = firstWorkoutDate;
    }

    final Map<String, Map<ChartDataType, int>> chartData = {};

    for (var i = intervalStart;
        i.isBefore(intervalEnd);
        i = chartTime == ChartTime.allTime
            ? i.add(months: 1)
            : i.add(days: 1)) {
      final binData = LinkedHashMap<ChartDataType, int>();

      for (var workout in workoutsHistory) {
        final workoutDate = Jiffy.parseFromDateTime(workout.timestamp.toDate());

        if (aggregationCondition(chartTime)(i, workoutDate)) {
          binData.update(ChartDataType.exercises,
              (value) => value + workout.numOfExercises,
              ifAbsent: () => workout.numOfExercises);
          binData.update(
              ChartDataType.sets, (value) => value + workout.numOfSets,
              ifAbsent: () => workout.numOfSets);
          binData.update(
              ChartDataType.time, (value) => value + workout.timeInSeconds,
              ifAbsent: () => workout.timeInSeconds);
        }
      }

      if (chartTime == ChartTime.lastWeek) {
        chartData[_getWeekdayName(i)] = binData;
      }
      if (chartTime == ChartTime.thisMonth) {
        chartData[i.date.toString()] = binData;
      }
      if (chartTime == ChartTime.allTime) {
        chartData[_getShortMonthName(i)] = binData;
      }
    }

    return chartData;
  }

  String _getWeekdayName(Jiffy date) {
    switch (date.dayOfWeek) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  String _getShortMonthName(Jiffy date) {
    switch (date.month) {
      case DateTime.january:
        return 'Jan';
      case DateTime.february:
        return 'Feb';
      case DateTime.march:
        return 'Mar';
      case DateTime.april:
        return 'Apr';
      case DateTime.may:
        return 'May';
      case DateTime.june:
        return 'Jun';
      case DateTime.july:
        return 'Jul';
      case DateTime.august:
        return 'Aug';
      case DateTime.september:
        return 'Sep';
      case DateTime.october:
        return 'Oct';
      case DateTime.november:
        return 'Nov';
      case DateTime.december:
        return 'Dec';
      default:
        return '';
    }
  }

  bool Function(Jiffy date1, Jiffy date2) aggregationCondition(
      ChartTime chartTime) {
    if (chartTime == ChartTime.lastWeek || chartTime == ChartTime.thisMonth) {
      return (date1, date2) =>
          date1.year == date2.year &&
          date1.month == date2.month &&
          date1.date == date2.date;
    } else {
      return (date1, date2) =>
          date1.year == date2.year && date1.month == date2.month;
    }
  }
}
