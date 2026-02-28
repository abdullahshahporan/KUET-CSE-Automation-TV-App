import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/tv_theme.dart';

/// A compact card showing a room's availability status.
class RoomStatusCard extends StatelessWidget {
  final Room room;

  const RoomStatusCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final available = room.isAvailable;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TVTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: available ? TVTheme.priorityLow.withValues(alpha: 0.4) : TVTheme.priorityHigh.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (available ? TVTheme.priorityLow : TVTheme.priorityHigh)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _roomIcon,
                  size: 22,
                  color: available ? TVTheme.priorityLow : TVTheme.priorityHigh,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: TVTheme.textPrimary,
                      ),
                    ),
                    Text(
                      room.displayType,
                      style: const TextStyle(
                        fontSize: 12,
                        color: TVTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (available ? TVTheme.priorityLow : TVTheme.priorityHigh)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  available ? 'Available' : 'Occupied',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: available ? TVTheme.priorityLow : TVTheme.priorityHigh,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Details
          Row(
            children: [
              const Icon(Icons.people_outline, size: 14, color: TVTheme.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Capacity: ${room.capacity}',
                style: const TextStyle(fontSize: 12, color: TVTheme.textSecondary),
              ),
              if (!available && room.occupiedBy != null) ...[
                const SizedBox(width: 16),
                const Icon(Icons.book_outlined, size: 14, color: TVTheme.accentLight),
                const SizedBox(width: 6),
                Text(
                  room.occupiedBy!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: TVTheme.accentLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),

          if (room.facilities.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: room.facilities
                  .map((f) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: TVTheme.border.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          f,
                          style: const TextStyle(fontSize: 10, color: TVTheme.textSecondary),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  IconData get _roomIcon {
    switch (room.type) {
      case RoomType.classroom:
        return Icons.school_outlined;
      case RoomType.lab:
        return Icons.computer_outlined;
      case RoomType.seminar:
        return Icons.mic_outlined;
      case RoomType.research:
        return Icons.science_outlined;
    }
  }
}
