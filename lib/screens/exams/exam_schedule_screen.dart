import 'package:flutter/material.dart';
import '../../services/services.dart';
import '../../theme/tv_theme.dart';
import '../../widgets/common/common.dart';

/// Shows upcoming exams / tests in a table-like layout.
class ExamScheduleScreen extends StatelessWidget {
  ExamScheduleScreen({super.key});

  final _service = ExamService();

  Color _examTypeColor(String type) {
    switch (type) {
      case 'CT':
        return TVTheme.typeClassTest;
      case 'Quiz':
        return TVTheme.typeQuiz;
      case 'Mid-Term':
        return TVTheme.priorityMedium;
      case 'Final':
        return TVTheme.priorityHigh;
      case 'Viva':
        return TVTheme.typeEvent;
      default:
        return TVTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exams = _service.getUpcomingExams();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Icon(Icons.quiz_outlined, color: TVTheme.accent, size: 28),
              SizedBox(width: 12),
              Text(
                'Upcoming Exams',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TVTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: TVTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Expanded(flex: 2, child: Text('Course', style: TextStyle(fontWeight: FontWeight.w600, color: TVTheme.textSecondary, fontSize: 13))),
              Expanded(flex: 1, child: Text('Type', style: TextStyle(fontWeight: FontWeight.w600, color: TVTheme.textSecondary, fontSize: 13))),
              Expanded(flex: 1, child: Text('Date', style: TextStyle(fontWeight: FontWeight.w600, color: TVTheme.textSecondary, fontSize: 13))),
              Expanded(flex: 1, child: Text('Time', style: TextStyle(fontWeight: FontWeight.w600, color: TVTheme.textSecondary, fontSize: 13))),
              Expanded(flex: 1, child: Text('Room', style: TextStyle(fontWeight: FontWeight.w600, color: TVTheme.textSecondary, fontSize: 13))),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Rows
        Expanded(
          child: exams.isEmpty
              ? const Center(
                  child: Text(
                    'No upcoming exams',
                    style: TextStyle(color: TVTheme.textSecondary, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: exams.length,
                  itemBuilder: (_, i) {
                    final e = exams[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: TVTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: TVTheme.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.courseCode,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: TVTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  e.courseName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: TVTheme.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TVBadge(
                              label: e.examType,
                              color: _examTypeColor(e.examType),
                              fontSize: 12,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              e.date,
                              style: const TextStyle(
                                  fontSize: 13, color: TVTheme.silver),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${e.startTime} – ${e.endTime}',
                              style: const TextStyle(
                                  fontSize: 13, color: TVTheme.textSecondary),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              e.room,
                              style: const TextStyle(
                                  fontSize: 13, color: TVTheme.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
