import 'package:flutter/material.dart';
import '../../services/services.dart';
import '../../theme/tv_theme.dart';
import '../../widgets/rooms/rooms.dart';

/// Shows room availability across the department.
class RoomStatusScreen extends StatelessWidget {
  RoomStatusScreen({super.key});

  final _service = RoomService();

  @override
  Widget build(BuildContext context) {
    final rooms = _service.getAllRooms();
    final summary = _service.getSummary();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with summary
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              const Icon(Icons.meeting_room_outlined, color: TVTheme.accent, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Room Status',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TVTheme.textPrimary,
                ),
              ),
              const Spacer(),
              _SummaryChip(
                label: '${summary.available} Available',
                color: TVTheme.priorityLow,
              ),
              const SizedBox(width: 10),
              _SummaryChip(
                label: '${summary.occupied} Occupied',
                color: TVTheme.priorityHigh,
              ),
            ],
          ),
        ),

        // Grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.8,
            ),
            itemCount: rooms.length,
            itemBuilder: (_, i) => RoomStatusCard(room: rooms[i]),
          ),
        ),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final Color color;

  const _SummaryChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
