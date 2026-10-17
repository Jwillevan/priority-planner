DateTime calendarDay(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime weekStart(DateTime d) =>
    DateTime(d.year, d.month, d.day - (d.weekday - 1));
// Always derive a monthly occurrence from its original day (Jan 31 -> Feb 28 -> Mar 31).
List<DateTime> recurrenceDates(
  DateTime anchor,
  String frequency,
  DateTime from,
  DateTime to,
) {
  if (!['daily', 'weekly', 'monthly'].contains(frequency)) {
    throw ArgumentError('Unknown frequency');
  }
  anchor = calendarDay(anchor);
  from = calendarDay(from);
  to = calendarDay(to);
  if (to.isBefore(from) || to.difference(from).inDays > 366) {
    throw ArgumentError('Choose a range of at most 367 days');
  }
  final result = <DateTime>[];
  for (
    var day = from;
    !day.isAfter(to);
    day = DateTime(day.year, day.month, day.day + 1)
  ) {
    if (day.isBefore(anchor)) continue;
    final difference = DateTime.utc(
      day.year,
      day.month,
      day.day,
    ).difference(DateTime.utc(anchor.year, anchor.month, anchor.day)).inDays;
    final last = DateTime(day.year, day.month + 1, 0).day;
    if (frequency == 'daily' ||
        frequency == 'weekly' && difference % 7 == 0 ||
        frequency == 'monthly' &&
            day.day == (anchor.day > last ? last : anchor.day)) {
      result.add(day);
    }
  }
  return result;
}
