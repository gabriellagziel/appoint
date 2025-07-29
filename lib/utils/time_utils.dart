String getCurrentWeekKey() {
  final now = DateTime.now();
  final week = ((now.day - now.weekday + 10) / 7).floor();
  return '${now.year}-W$week';
}
