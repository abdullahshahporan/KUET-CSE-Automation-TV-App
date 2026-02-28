/// Matches web portal's Room interface
enum RoomType { classroom, lab, seminar, research }

class Room {
  final String id;
  final String name;
  final String building;
  final int capacity;
  final RoomType type;
  final bool isAvailable;
  final String? occupiedBy; // course code or event
  final List<String> facilities;

  const Room({
    required this.id,
    required this.name,
    required this.building,
    required this.capacity,
    required this.type,
    required this.isAvailable,
    this.occupiedBy,
    this.facilities = const [],
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      name: json['name'] as String,
      building: json['building'] as String,
      capacity: json['capacity'] as int,
      type: _parseType(json['type'] as String),
      isAvailable: json['isAvailable'] as bool,
      occupiedBy: json['occupiedBy'] as String?,
      facilities: (json['facilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'building': building,
        'capacity': capacity,
        'type': type.name,
        'isAvailable': isAvailable,
        'occupiedBy': occupiedBy,
        'facilities': facilities,
      };

  static RoomType _parseType(String raw) {
    const map = {
      'classroom': RoomType.classroom,
      'lab': RoomType.lab,
      'seminar': RoomType.seminar,
      'research': RoomType.research,
    };
    return map[raw] ?? RoomType.classroom;
  }

  String get displayType {
    const map = {
      RoomType.classroom: 'Classroom',
      RoomType.lab: 'Lab',
      RoomType.seminar: 'Seminar Hall',
      RoomType.research: 'Research Lab',
    };
    return map[type] ?? 'Room';
  }
}
