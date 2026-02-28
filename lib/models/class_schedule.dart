/// Matches web portal's ClassSchedule interface
class ClassSchedule {
  final String id;
  final String courseCode;
  final String courseName;
  final String teacherId;
  final String teacherName;
  final String roomId;
  final String roomName;
  final String day; // Sunday .. Saturday
  final String startTime; // "09:00"
  final String endTime; // "10:30"
  final String? section;
  final String? group;

  const ClassSchedule({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.teacherId,
    required this.teacherName,
    required this.roomId,
    required this.roomName,
    required this.day,
    required this.startTime,
    required this.endTime,
    this.section,
    this.group,
  });

  factory ClassSchedule.fromJson(Map<String, dynamic> json) {
    return ClassSchedule(
      id: json['id'] as String,
      courseCode: json['courseCode'] as String,
      courseName: json['courseName'] as String,
      teacherId: json['teacherId'] as String,
      teacherName: json['teacherName'] as String,
      roomId: json['roomId'] as String,
      roomName: json['roomName'] as String,
      day: json['day'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      section: json['section'] as String?,
      group: json['group'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseCode': courseCode,
        'courseName': courseName,
        'teacherId': teacherId,
        'teacherName': teacherName,
        'roomId': roomId,
        'roomName': roomName,
        'day': day,
        'startTime': startTime,
        'endTime': endTime,
        'section': section,
        'group': group,
      };
}
