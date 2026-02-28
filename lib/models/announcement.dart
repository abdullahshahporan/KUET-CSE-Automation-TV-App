/// Types matching the web portal's Announcement interface
enum AnnouncementType {
  notice,
  classTest,
  assignment,
  labTest,
  quiz,
  event,
  other,
}

enum Priority { low, medium, high }

class Announcement {
  final String id;
  final String title;
  final String content;
  final AnnouncementType type;
  final String? courseCode;
  final String createdBy;
  final String createdAt;
  final String? scheduledDate;
  final bool isActive;
  final Priority priority;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.courseCode,
    required this.createdBy,
    required this.createdAt,
    this.scheduledDate,
    required this.isActive,
    required this.priority,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: _parseType(json['type'] as String),
      courseCode: json['courseCode'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
      scheduledDate: json['scheduledDate'] as String?,
      isActive: json['isActive'] as bool,
      priority: _parsePriority(json['priority'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'type': typeToString(type),
        'courseCode': courseCode,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'scheduledDate': scheduledDate,
        'isActive': isActive,
        'priority': priority.name,
      };

  // ── helpers ──────────────────────────────────────────────
  static AnnouncementType _parseType(String raw) {
    const map = {
      'notice': AnnouncementType.notice,
      'class-test': AnnouncementType.classTest,
      'assignment': AnnouncementType.assignment,
      'lab-test': AnnouncementType.labTest,
      'quiz': AnnouncementType.quiz,
      'event': AnnouncementType.event,
      'other': AnnouncementType.other,
    };
    return map[raw] ?? AnnouncementType.other;
  }

  static Priority _parsePriority(String raw) {
    const map = {
      'low': Priority.low,
      'medium': Priority.medium,
      'high': Priority.high,
    };
    return map[raw] ?? Priority.medium;
  }

  static String typeToString(AnnouncementType t) {
    const map = {
      AnnouncementType.notice: 'notice',
      AnnouncementType.classTest: 'class-test',
      AnnouncementType.assignment: 'assignment',
      AnnouncementType.labTest: 'lab-test',
      AnnouncementType.quiz: 'quiz',
      AnnouncementType.event: 'event',
      AnnouncementType.other: 'other',
    };
    return map[t] ?? 'other';
  }

  String get displayType {
    const map = {
      AnnouncementType.notice: 'Notice',
      AnnouncementType.classTest: 'Class Test',
      AnnouncementType.assignment: 'Assignment',
      AnnouncementType.labTest: 'Lab Test',
      AnnouncementType.quiz: 'Quiz',
      AnnouncementType.event: 'Event',
      AnnouncementType.other: 'Other',
    };
    return map[type] ?? 'Other';
  }
}
