import '../data/dummy_data.dart';
import '../models/models.dart';

/// Service to provide announcement data.
/// Currently uses dummy data; replace with Supabase calls later.
class AnnouncementService {
  /// Get all active announcements, sorted by priority then date.
  List<Announcement> getActiveAnnouncements() {
    final active = dummyAnnouncements.where((a) => a.isActive).toList();
    active.sort((a, b) {
      final priorityOrder = {Priority.high: 0, Priority.medium: 1, Priority.low: 2};
      final cmp = (priorityOrder[a.priority] ?? 2)
          .compareTo(priorityOrder[b.priority] ?? 2);
      if (cmp != 0) return cmp;
      return b.createdAt.compareTo(a.createdAt);
    });
    return active;
  }

  /// Get all announcements
  List<Announcement> getAllAnnouncements() => List.unmodifiable(dummyAnnouncements);

  /// Get announcements by type
  List<Announcement> getByType(AnnouncementType type) =>
      dummyAnnouncements.where((a) => a.type == type && a.isActive).toList();

  /// Get high priority announcements
  List<Announcement> getUrgent() =>
      dummyAnnouncements
          .where((a) => a.priority == Priority.high && a.isActive)
          .toList();
}
