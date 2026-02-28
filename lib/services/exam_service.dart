import '../data/dummy_data.dart';
import '../models/models.dart';

/// Service to provide exam schedule data.
class ExamService {
  /// Get all exam schedules
  List<ExamSchedule> getAllExams() => List.unmodifiable(dummyExamSchedules);

  /// Get upcoming exams (sorted by date)
  List<ExamSchedule> getUpcomingExams() {
    final sorted = List<ExamSchedule>.from(dummyExamSchedules);
    sorted.sort((a, b) => a.date.compareTo(b.date));
    return sorted;
  }

  /// Get exams by type
  List<ExamSchedule> getExamsByType(String examType) =>
      dummyExamSchedules.where((e) => e.examType == examType).toList();
}
