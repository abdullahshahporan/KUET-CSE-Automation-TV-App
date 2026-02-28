import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/constants.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../theme/tv_theme.dart';
import '../widgets/common/common.dart';

/// The root TV shell — professional broadcast-style layout.
/// Layout (top to bottom):
///   1. Compact broadcast header (gradient + LIVE badge + clock)
///   2. Subtle channel-style nav strip
///   3. Big main content area (screens)
///   4. Special Updates bar
///   5. Bottom headline ticker
class TVShell extends StatefulWidget {
  const TVShell({super.key});

  @override
  State<TVShell> createState() => _TVShellState();
}

class _TVShellState extends State<TVShell> {
  int _currentIndex = 0;
  Timer? _autoRotateTimer;

  final _tabs = const <_TabInfo>[
    _TabInfo(icon: Icons.dashboard_outlined, label: 'Dashboard'),
    _TabInfo(icon: Icons.campaign_outlined, label: 'Announcements'),
    _TabInfo(icon: Icons.schedule_outlined, label: 'Routine'),
    _TabInfo(icon: Icons.meeting_room_outlined, label: 'Rooms'),
    _TabInfo(icon: Icons.quiz_outlined, label: 'Exams'),
  ];

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _screens = [
      DashboardScreen(),
      AnnouncementsScreen(),
      const ScheduleScreen(),
      RoomStatusScreen(),
      ExamScheduleScreen(),
    ];

    _startAutoRotate();
  }

  void _startAutoRotate() {
    _autoRotateTimer = Timer.periodic(
      const Duration(seconds: AppConstants.pageRotateInterval),
      (_) {
        if (!mounted) return;
        setState(() {
          _currentIndex = (_currentIndex + 1) % _tabs.length;
        });
      },
    );
  }

  void _goToTab(int index) {
    _autoRotateTimer?.cancel();
    setState(() => _currentIndex = index);
    _startAutoRotate();
  }

  @override
  void dispose() {
    _autoRotateTimer?.cancel();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final announcementService = AnnouncementService();
    final allAnnouncements = announcementService.getActiveAnnouncements();
    final urgentAnnouncements = announcementService.getUrgent();

    return Scaffold(
      backgroundColor: TVTheme.background,
      body: Column(
        children: [
          // ── 1. Premium broadcast header ─────────────────
          _buildBroadcastHeader(),

          // ── 2. Channel-style nav strip ──────────────────
          _buildChannelNav(),

          // ── 3. Big main content ─────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.02, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey(_currentIndex),
                  child: _screens[_currentIndex],
                ),
              ),
            ),
          ),

          // ── 4. Special Updates bar ──────────────────────
          SpecialUpdatesBar(updates: urgentAnnouncements),

          // ── 5. Bottom headline ticker ───────────────────
          HeadlineTicker(announcements: allAnnouncements),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Premium broadcast header — gradient, glow, LIVE badge
  // ─────────────────────────────────────────────────────────
  Widget _buildBroadcastHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [TVTheme.headerGradientStart, TVTheme.headerGradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: TVTheme.accent.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: TVTheme.accent.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Logo / Branding ──
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TVTheme.accent.withValues(alpha: 0.2),
                  TVTheme.accentLight.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: TVTheme.accent.withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(Icons.school, color: TVTheme.accent, size: 26),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'CSE',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: TVTheme.textPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 2,
                    height: 18,
                    color: TVTheme.accent,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'KUET',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: TVTheme.accent,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const Text(
                'Department of Computer Science & Engineering',
                style: TextStyle(
                  fontSize: 11,
                  color: TVTheme.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          const LiveBadge(),
          const Spacer(),

          // ── Current section indicator ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: TVTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: TVTheme.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _tabs[_currentIndex].icon,
                  size: 14,
                  color: TVTheme.accent,
                ),
                const SizedBox(width: 8),
                Text(
                  _tabs[_currentIndex].label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: TVTheme.textPrimary,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          const ClockWidget(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Channel-style navigation strip — compact, subtle
  // ─────────────────────────────────────────────────────────
  Widget _buildChannelNav() {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: TVTheme.surface,
        border: Border(
          bottom: BorderSide(color: TVTheme.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Channel tabs
          ...List.generate(_tabs.length, (i) {
            final tab = _tabs[i];
            final selected = i == _currentIndex;
            return GestureDetector(
              onTap: () => _goToTab(i),
              child: Container(
                margin: const EdgeInsets.only(right: 2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? TVTheme.accent.withValues(alpha: 0.15)
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: selected ? TVTheme.accent : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab.icon,
                      size: 15,
                      color: selected ? TVTheme.accent : TVTheme.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tab.label.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected
                            ? TVTheme.textPrimary
                            : TVTheme.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const Spacer(),

          // Semester indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: TVTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: TVTheme.border.withValues(alpha: 0.5),
              ),
            ),
            child: const Text(
              'SPRING 2026',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: TVTheme.gold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabInfo {
  final IconData icon;
  final String label;
  const _TabInfo({required this.icon, required this.label});
}
