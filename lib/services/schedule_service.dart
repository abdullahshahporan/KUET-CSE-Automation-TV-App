import '../data/dummy_data.dart';
import '../models/models.dart';

/// Service to provide class schedule / routine data.
class ScheduleService {
  /// Get all schedules
  List<ClassSchedule> getAllSchedules() => List.unmodifiable(dummySchedules);

  /// Get today's schedule based on the current day name
  List<ClassSchedule> getTodaySchedules() {
    final now = DateTime.now();
    final dayName = _dayName(now.weekday);
    return getSchedulesByDay(dayName);
  }

  /// Get schedules for a specific day
  List<ClassSchedule> getSchedulesByDay(String day) {
    final result = dummySchedules
        .where((s) => s.day.toLowerCase() == day.toLowerCase())
        .toList();
    result.sort((a, b) => a.startTime.compareTo(b.startTime));
    return result;
  }

  /// Get the current / next upcoming class
  ClassSchedule? getCurrentOrNextClass() {
    final today = getTodaySchedules();
    if (today.isEmpty) return null;

    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;

    for (final s in today) {
      final endParts = s.endTime.split(':');
      final endMinutes =
          int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
      if (currentMinutes < endMinutes) return s;
    }
    return null;
  }

  /// Week days helper
  static const List<String> weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
  ];

  String _dayName(int weekday) {
    const map = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };
    return map[weekday] ?? 'Sunday';
  }
}
