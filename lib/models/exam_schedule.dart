/// Matches web portal's ExamSchedule interface
class ExamSchedule {
  final String id;
  final String courseCode;
  final String courseName;
  final String examType; // CT, Quiz, Mid-Term, Final, Viva
  final String date;
  final String startTime;
  final String endTime;
  final String room;
  final String? syllabus;

  const ExamSchedule({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.examType,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.room,
    this.syllabus,
  });

  factory ExamSchedule.fromJson(Map<String, dynamic> json) {
    return ExamSchedule(
      id: json['id'] as String,
      courseCode: json['courseCode'] as String,
      courseName: json['courseName'] as String,
      examType: json['examType'] as String,
      date: json['date'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      room: json['room'] as String,
      syllabus: json['syllabus'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseCode': courseCode,
        'courseName': courseName,
        'examType': examType,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'room': room,
        'syllabus': syllabus,
      };
}
