import '../data/dummy_data.dart';
import '../models/models.dart';

/// Service to provide room availability data.
class RoomService {
  /// Get all rooms
  List<Room> getAllRooms() => List.unmodifiable(dummyRooms);

  /// Get available rooms
  List<Room> getAvailableRooms() =>
      dummyRooms.where((r) => r.isAvailable).toList();

  /// Get occupied rooms
  List<Room> getOccupiedRooms() =>
      dummyRooms.where((r) => !r.isAvailable).toList();

  /// Get rooms by type
  List<Room> getRoomsByType(RoomType type) =>
      dummyRooms.where((r) => r.type == type).toList();

  /// Room summary counts
  ({int total, int available, int occupied}) getSummary() {
    return (
      total: dummyRooms.length,
      available: dummyRooms.where((r) => r.isAvailable).length,
      occupied: dummyRooms.where((r) => !r.isAvailable).length,
    );
  }
}
