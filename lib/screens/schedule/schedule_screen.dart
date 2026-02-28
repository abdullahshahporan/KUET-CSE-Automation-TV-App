import 'package:flutter/material.dart';
import '../../services/services.dart';
import '../../theme/tv_theme.dart';
import '../../widgets/schedule/schedule.dart';

/// Displays today's class routine with day-tabs.
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _service = ScheduleService();
  late String _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _todayName();
  }

  String _todayName() {
    const map = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };
    return map[DateTime.now().weekday] ?? 'Sunday';
  }

  @override
  Widget build(BuildContext context) {
    final schedules = _service.getSchedulesByDay(_selectedDay);
    final currentClass = _service.getCurrentOrNextClass();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(Icons.schedule_outlined, color: TVTheme.accent, size: 28),
              SizedBox(width: 12),
              Text(
                'Class Routine',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TVTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // Day tabs
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: ScheduleService.weekDays.map((day) {
              final isSelected = day == _selectedDay;
              return GestureDetector(
                onTap: () => setState(() => _selectedDay = day),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? TVTheme.accent : TVTheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? TVTheme.accent : TVTheme.border,
                    ),
                  ),
                  child: Text(
                    day,
                    style: TextStyle(
                      color: isSelected ? Colors.white : TVTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Schedule list
        Expanded(
          child: schedules.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.event_busy_outlined, size: 48, color: TVTheme.textSecondary.withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      Text(
                        'No classes on $_selectedDay',
                        style: const TextStyle(color: TVTheme.textSecondary, fontSize: 18),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (_, i) {
                    final s = schedules[i];
                    return ScheduleRow(
                      schedule: s,
                      isCurrentClass:
                          currentClass != null && currentClass.id == s.id,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
