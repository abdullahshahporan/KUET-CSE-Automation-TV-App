import 'package:flutter/material.dart';
import '../../services/services.dart';
import '../../theme/tv_theme.dart';
import '../../widgets/announcements/announcements.dart';
import '../../widgets/common/common.dart';
import '../../widgets/rooms/rooms.dart';
import '../../widgets/schedule/schedule.dart';

/// Overview dashboard — shows today's schedule, urgent announcements, room status, and exams at once.
class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final _announcementService = AnnouncementService();
  final _scheduleService = ScheduleService();
  final _roomService = RoomService();
  final _examService = ExamService();

  @override
  Widget build(BuildContext context) {
    final announcements = _announcementService.getActiveAnnouncements();
    final todaySchedules = _scheduleService.getTodaySchedules();
    final currentClass = _scheduleService.getCurrentOrNextClass();
    final rooms = _roomService.getAllRooms();
    final exams = _examService.getUpcomingExams();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Left column (60%) ─ schedule + exams ────────────
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's schedule
              const _SectionTitle(icon: Icons.schedule_outlined, title: "Today's Schedule"),
              const SizedBox(height: 10),
              Expanded(
                flex: 5,
                child: todaySchedules.isEmpty
                    ? Center(
                        child: Text(
                          'No classes today',
                          style: TextStyle(
                            color: TVTheme.textSecondary.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: todaySchedules.length,
                        itemBuilder: (_, i) => ScheduleRow(
                          schedule: todaySchedules[i],
                          isCurrentClass: currentClass != null &&
                              currentClass.id == todaySchedules[i].id,
                        ),
                      ),
              ),

              const Divider(color: TVTheme.border, height: 32),

              // Upcoming exams  (compact)
              const _SectionTitle(icon: Icons.quiz_outlined, title: 'Upcoming Exams'),
              const SizedBox(height: 10),
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: exams.length > 3 ? 3 : exams.length,
                  itemBuilder: (_, i) {
                    final e = exams[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: TVTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: TVTheme.border),
                      ),
                      child: Row(
                        children: [
                          TVBadge(label: e.examType, color: TVTheme.accent),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              '${e.courseCode} — ${e.courseName}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: TVTheme.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${e.date}  ${e.startTime}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: TVTheme.silver,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(e.room,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: TVTheme.textSecondary)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 24),

        // ── Right column (40%) ─ announcements + rooms ────
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Announcements
              const _SectionTitle(
                  icon: Icons.campaign_outlined, title: 'Announcements'),
              const SizedBox(height: 10),
              Expanded(
                flex: 5,
                child: ListView.builder(
                  itemCount: announcements.length > 4 ? 4 : announcements.length,
                  itemBuilder: (_, i) =>
                      AnnouncementCard(announcement: announcements[i]),
                ),
              ),

              const Divider(color: TVTheme.border, height: 32),

              // Room status
              const _SectionTitle(
                  icon: Icons.meeting_room_outlined, title: 'Room Status'),
              const SizedBox(height: 10),
              Expanded(
                flex: 3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: rooms.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 280,
                      child: RoomStatusCard(room: rooms[i]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: TVTheme.accent, size: 22),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: TVTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
