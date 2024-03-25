String timeFormat(int seconds) {
  if (seconds >= 0 && seconds <= 59) {
    return '${seconds}s';
  }
  if (seconds >= 60 && seconds <= 3599) {
    return '${(seconds / 60).round()}m';
  } else {
    return '${(seconds / 3600).round()}h ${((seconds % 3600) / 60).round()}m';
  }
}
