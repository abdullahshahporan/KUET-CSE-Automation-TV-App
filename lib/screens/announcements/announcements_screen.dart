import 'package:flutter/material.dart';
import '../../services/services.dart';
import '../../theme/tv_theme.dart';
import '../../widgets/announcements/announcements.dart';

/// Full-screen view of all active announcements.
class AnnouncementsScreen extends StatelessWidget {
  AnnouncementsScreen({super.key});

  final _service = AnnouncementService();

  @override
  Widget build(BuildContext context) {
    final announcements = _service.getActiveAnnouncements();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Icon(Icons.campaign_outlined, color: TVTheme.accent, size: 28),
              SizedBox(width: 12),
              Text(
                'Announcements',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TVTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: announcements.isEmpty
              ? const Center(
                  child: Text(
                    'No active announcements',
                    style: TextStyle(color: TVTheme.textSecondary, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (_, i) =>
                      AnnouncementCard(announcement: announcements[i]),
                ),
        ),
      ],
    );
  }
}
