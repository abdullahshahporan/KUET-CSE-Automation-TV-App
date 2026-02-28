import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/tv_theme.dart';

/// Displays a single class-schedule row for a routine table.
class ScheduleRow extends StatelessWidget {
  final ClassSchedule schedule;
  final bool isCurrentClass;

  const ScheduleRow({
    super.key,
    required this.schedule,
    this.isCurrentClass = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isCurrentClass
            ? TVTheme.accent.withValues(alpha: 0.10)
            : TVTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentClass ? TVTheme.accent : TVTheme.border,
          width: isCurrentClass ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Time column
          SizedBox(
            width: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${schedule.startTime} – ${schedule.endTime}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isCurrentClass ? TVTheme.accentLight : TVTheme.textPrimary,
                  ),
                ),
                if (isCurrentClass)
                  const Text(
                    'NOW',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: TVTheme.accentLight,
                      letterSpacing: 1,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Divider
          Container(
            width: 2,
            height: 40,
            decoration: BoxDecoration(
              color: isCurrentClass ? TVTheme.accent : TVTheme.border,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(width: 16),

          // Course info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${schedule.courseCode} — ${schedule.courseName}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: TVTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  schedule.teacherName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: TVTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Room + section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.room_outlined, size: 14, color: TVTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    schedule.roomName,
                    style: const TextStyle(fontSize: 13, color: TVTheme.silver),
                  ),
                ],
              ),
              if (schedule.section != null || schedule.group != null)
                Text(
                  schedule.section != null
                      ? 'Section ${schedule.section}'
                      : 'Group ${schedule.group}',
                  style: const TextStyle(fontSize: 12, color: TVTheme.textSecondary),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
