import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/constants.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../theme/tv_theme.dart';
import '../widgets/announcements/announcements.dart';
import '../widgets/common/common.dart';

/// The root TV shell — header, navigation bar, content area, and announcement ticker.
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
    // Landscape orientation lock for TV
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Hide system UI for fullscreen kiosk feel
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
    // Reset auto-rotate timer on manual navigation
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
    final urgentAnnouncements = AnnouncementService().getUrgent();

    return Scaffold(
      backgroundColor: TVTheme.background,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────
          _buildHeader(),

          // ── Urgent ticker ──────────────────────────────
          AnnouncementTicker(announcements: urgentAnnouncements),

          // ── Navigation bar ─────────────────────────────
          _buildNavBar(),

          // ── Content area ───────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: KeyedSubtree(
                  key: ValueKey(_currentIndex),
                  child: _screens[_currentIndex],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: const BoxDecoration(
        color: TVTheme.surface,
        border: Border(bottom: BorderSide(color: TVTheme.border)),
      ),
      child: Row(
        children: [
          // Logo / Department name
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TVTheme.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.school, color: TVTheme.accent, size: 28),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.departmentName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TVTheme.textPrimary,
                ),
              ),
              Text(
                AppConstants.universityName,
                style: TextStyle(fontSize: 12, color: TVTheme.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          const ClockWidget(),
        ],
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: TVTheme.surfaceVariant,
        border: Border(bottom: BorderSide(color: TVTheme.border)),
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final tab = _tabs[i];
          final selected = i == _currentIndex;
          return GestureDetector(
            onTap: () => _goToTab(i),
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? TVTheme.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    tab.icon,
                    size: 18,
                    color: selected ? Colors.white : TVTheme.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tab.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      color: selected ? Colors.white : TVTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TabInfo {
  final IconData icon;
  final String label;
  const _TabInfo({required this.icon, required this.label});
}
