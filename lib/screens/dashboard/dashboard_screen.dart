import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../theme/tv_theme.dart';
import '../../widgets/common/common.dart';
import '../../widgets/rooms/rooms.dart';

/// Professional broadcast-style dashboard.
/// Layout:
///   Top (big):  Featured hero panel (current/next class or featured announcement)
///   Below:      3-column grid — Today's schedule | Announcements | Rooms + Exams
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

    return Column(
      children: [
        // ══════════════════════════════════════════════
        // ── BIG CONTENT — Hero Feature Panel (top ~45%)
        // ══════════════════════════════════════════════
        Expanded(
          flex: 5,
          child: Row(
            children: [
              // ── Main hero: current/next class ──
              Expanded(
                flex: 6,
                child: _buildHeroPanel(currentClass, todaySchedules),
              ),
              const SizedBox(width: 16),
              // ── Side: Featured announcement ──
              Expanded(
                flex: 4,
                child: _buildFeaturedAnnouncement(announcements),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ══════════════════════════════════════════════
        // ── LOWER GRID — Schedule, Announcements, Info
        // ══════════════════════════════════════════════
        Expanded(
          flex: 4,
          child: Row(
            children: [
              // ── Column 1: Today's Schedule ──
              Expanded(
                flex: 4,
                child: _buildSchedulePanel(todaySchedules, currentClass),
              ),
              const SizedBox(width: 12),
              // ── Column 2: Recent Announcements ──
              Expanded(
                flex: 3,
                child: _buildAnnouncementsPanel(announcements),
              ),
              const SizedBox(width: 12),
              // ── Column 3: Exams + Room Status ──
              Expanded(
                flex: 3,
                child: _buildInfoPanel(exams, rooms),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // Hero panel — large featured content (current/next class)
  // ─────────────────────────────────────────────────────────
  Widget _buildHeroPanel(
      ClassSchedule? current, List<ClassSchedule> todaySchedules) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TVTheme.surfaceElevated,
            TVTheme.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: current != null
              ? TVTheme.accent.withValues(alpha: 0.5)
              : TVTheme.border,
          width: current != null ? 1.5 : 1,
        ),
        boxShadow: current != null
            ? [
                BoxShadow(
                  color: TVTheme.accent.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: current != null
          ? _buildCurrentClassHero(current)
          : _buildNoClassHero(todaySchedules),
    );
  }

  Widget _buildCurrentClassHero(ClassSchedule cls) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NOW / NEXT label
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: TVTheme.accent,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: TVTheme.accent.withValues(alpha: 0.4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Text(
                  'NOW SHOWING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: TVTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: TVTheme.border),
                ),
                child: Text(
                  '${cls.startTime} – ${cls.endTime}',
                  style: const TextStyle(
                    color: TVTheme.silver,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),

          // Course code — BIG
          Text(
            cls.courseCode,
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: TVTheme.textPrimary,
              letterSpacing: 1,
              shadows: [
                Shadow(
                  color: TVTheme.accent.withValues(alpha: 0.3),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            cls.courseName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: TVTheme.silver,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),

          // Bottom info row
          Row(
            children: [
              _heroInfoChip(Icons.person_outline, cls.teacherName),
              const SizedBox(width: 20),
              _heroInfoChip(Icons.room_outlined, cls.roomName),
              if (cls.section != null) ...[
                const SizedBox(width: 20),
                _heroInfoChip(Icons.group_outlined, 'Section ${cls.section}'),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: TVTheme.accent),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: TVTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNoClassHero(List<ClassSchedule> todaySchedules) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: TVTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: TVTheme.border),
                ),
                child: const Text(
                  'CAMPUS STATUS',
                  style: TextStyle(
                    color: TVTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(
            todaySchedules.isEmpty
                ? Icons.weekend_outlined
                : Icons.access_time_outlined,
            size: 48,
            color: TVTheme.accent.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            todaySchedules.isEmpty ? 'No Classes Today' : 'Between Classes',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: TVTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            todaySchedules.isEmpty
                ? 'Enjoy your day off!'
                : '${todaySchedules.length} classes scheduled today',
            style: const TextStyle(
              fontSize: 18,
              color: TVTheme.textSecondary,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Featured announcement — right side hero area
  // ─────────────────────────────────────────────────────────
  Widget _buildFeaturedAnnouncement(List<Announcement> announcements) {
    if (announcements.isEmpty) {
      return _panelContainer(
        child: const Center(
          child: Text(
            'No announcements',
            style: TextStyle(color: TVTheme.textSecondary),
          ),
        ),
      );
    }

    final featured = announcements.first;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TVTheme.surfaceElevated,
            TVTheme.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _announcementBorderColor(featured.priority),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: TVTheme.breakingOrange,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: TVTheme.breakingOrange.withValues(alpha: 0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Text(
                    'FEATURED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TVBadge(
                  label: featured.displayType,
                  color: _typeColor(featured.type),
                  fontSize: 10,
                ),
              ],
            ),
            const Spacer(),
            if (featured.courseCode != null) ...[
              Text(
                featured.courseCode!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: TVTheme.accentLight,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
            ],
            Text(
              featured.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: TVTheme.textPrimary,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Text(
              featured.content,
              style: const TextStyle(
                fontSize: 14,
                color: TVTheme.textSecondary,
                height: 1.5,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            // Footer
            Row(
              children: [
                Icon(Icons.person_outline,
                    size: 14, color: TVTheme.textSecondary),
                const SizedBox(width: 6),
                Text(
                  featured.createdBy,
                  style: const TextStyle(
                    fontSize: 12,
                    color: TVTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                if (featured.scheduledDate != null) ...[
                  Icon(Icons.event_outlined,
                      size: 14, color: TVTheme.accent),
                  const SizedBox(width: 6),
                  Text(
                    featured.scheduledDate!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: TVTheme.accent,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Lower panels
  // ─────────────────────────────────────────────────────────

  Widget _buildSchedulePanel(
      List<ClassSchedule> schedules, ClassSchedule? current) {
    return _panelContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _panelHeader(Icons.schedule_outlined, "TODAY'S SCHEDULE",
              '${schedules.length} classes'),
          const SizedBox(height: 10),
          Expanded(
            child: schedules.isEmpty
                ? Center(
                    child: Text(
                      'No classes today',
                      style: TextStyle(
                        color: TVTheme.textSecondary.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (_, i) {
                      final s = schedules[i];
                      final isCurrent =
                          current != null && current.id == s.id;
                      return _compactScheduleRow(s, isCurrent);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _compactScheduleRow(ClassSchedule s, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrent
            ? TVTheme.accent.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrent
              ? TVTheme.accent.withValues(alpha: 0.4)
              : TVTheme.border.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          // Time
          SizedBox(
            width: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.startTime}–${s.endTime}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isCurrent
                        ? TVTheme.accentLight
                        : TVTheme.textPrimary,
                  ),
                ),
                if (isCurrent)
                  Text(
                    'NOW',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: TVTheme.accentLight,
                      letterSpacing: 1,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            width: 2,
            height: 28,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isCurrent ? TVTheme.accent : TVTheme.border,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.courseCode} — ${s.courseName}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: TVTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  s.teacherName,
                  style: const TextStyle(
                    fontSize: 11,
                    color: TVTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            s.roomName,
            style: const TextStyle(
              fontSize: 11,
              color: TVTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsPanel(List<Announcement> announcements) {
    return _panelContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _panelHeader(Icons.campaign_outlined, 'ANNOUNCEMENTS',
              '${announcements.length} active'),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              // Skip the first (featured) one
              itemCount:
                  (announcements.length > 1 ? announcements.length - 1 : 0)
                      .clamp(0, 4),
              itemBuilder: (_, i) {
                final a = announcements[i + 1];
                return _compactAnnouncementRow(a);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _compactAnnouncementRow(Announcement a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: TVTheme.border.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          // Priority indicator
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              color: _priorityColor(a.priority),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: TVTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  a.content,
                  style: const TextStyle(
                    fontSize: 11,
                    color: TVTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TVBadge(
            label: a.displayType,
            color: _typeColor(a.type),
            fontSize: 9,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel(List<ExamSchedule> exams, List<Room> rooms) {
    return _panelContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _panelHeader(
              Icons.event_outlined, 'UPCOMING EXAMS', '${exams.length} exams'),
          const SizedBox(height: 8),
          // Exams — take ~55%
          Expanded(
            flex: 6,
            child: ListView.builder(
              itemCount: exams.length > 3 ? 3 : exams.length,
              itemBuilder: (_, i) {
                final e = exams[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: TVTheme.border.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      TVBadge(
                          label: e.examType,
                          color: TVTheme.accent,
                          fontSize: 10),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${e.courseCode} — ${e.courseName}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: TVTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        e.date,
                        style: const TextStyle(
                          fontSize: 11,
                          color: TVTheme.silver,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Rooms — take ~45%
          _panelHeader(
              Icons.meeting_room_outlined, 'ROOM STATUS', '${rooms.length} rooms'),
          const SizedBox(height: 6),
          Expanded(
            flex: 4,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: rooms.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SizedBox(
                  width: 200,
                  child: RoomStatusCard(room: rooms[i]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Shared panel building blocks
  // ─────────────────────────────────────────────────────────

  Widget _panelContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TVTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TVTheme.border, width: 0.5),
      ),
      child: child,
    );
  }

  Widget _panelHeader(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: TVTheme.accent, size: 16),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: TVTheme.textPrimary,
            letterSpacing: 1,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: TVTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: TVTheme.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // Color helpers
  // ─────────────────────────────────────────────────────────

  Color _priorityColor(Priority p) {
    switch (p) {
      case Priority.high:
        return TVTheme.priorityHigh;
      case Priority.medium:
        return TVTheme.priorityMedium;
      case Priority.low:
        return TVTheme.priorityLow;
    }
  }

  Color _typeColor(AnnouncementType type) {
    switch (type) {
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

  Color _announcementBorderColor(Priority p) {
    switch (p) {
      case Priority.high:
        return TVTheme.priorityHigh.withValues(alpha: 0.5);
      case Priority.medium:
        return TVTheme.priorityMedium.withValues(alpha: 0.4);
      case Priority.low:
        return TVTheme.border;
    }
  }
}
