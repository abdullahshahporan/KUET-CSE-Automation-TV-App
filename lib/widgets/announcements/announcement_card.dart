import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/tv_theme.dart';
import '../common/common.dart';

/// A single announcement card for the TV display.
class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({super.key, required this.announcement});

  Color get _priorityColor {
    switch (announcement.priority) {
      case Priority.high:
        return TVTheme.priorityHigh;
      case Priority.medium:
        return TVTheme.priorityMedium;
      case Priority.low:
        return TVTheme.priorityLow;
    }
  }

  Color get _typeColor {
    switch (announcement.type) {
      case AnnouncementType.classTest:
        return TVTheme.typeClassTest;
      case AnnouncementType.assignment:
        return TVTheme.typeAssignment;
      case AnnouncementType.notice:
        return TVTheme.typeNotice;
      case AnnouncementType.event:
        return TVTheme.typeEvent;
      case AnnouncementType.labTest:
        return TVTheme.typeLabTest;
      case AnnouncementType.quiz:
        return TVTheme.typeQuiz;
      case AnnouncementType.other:
        return TVTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TVTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TVTheme.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Priority strip
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: _priorityColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            announcement.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: TVTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        TVBadge(label: announcement.displayType, color: _typeColor),
                        if (announcement.courseCode != null) ...[
                          const SizedBox(width: 8),
                          TVBadge(
                            label: announcement.courseCode!,
                            color: TVTheme.accentLight,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Content
                    Text(
                      announcement.content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: TVTheme.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Footer
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: TVTheme.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          'Created: ${announcement.createdAt}',
                          style: const TextStyle(fontSize: 12, color: TVTheme.textSecondary),
                        ),
                        if (announcement.scheduledDate != null) ...[
                          const SizedBox(width: 20),
                          Icon(Icons.schedule, size: 14, color: TVTheme.silver),
                          const SizedBox(width: 6),
                          Text(
                            'Scheduled: ${announcement.scheduledDate}',
                            style: TextStyle(
                              fontSize: 12,
                              color: TVTheme.silver,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          announcement.createdBy,
                          style: const TextStyle(fontSize: 12, color: TVTheme.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
