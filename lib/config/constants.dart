/// App-wide constants for the TV display
class AppConstants {
  AppConstants._();

  static const String appName = 'KUET CSE Display';
  static const String departmentName = 'Department of Computer Science & Engineering';
  static const String universityName = 'Khulna University of Engineering & Technology';

  /// Auto-scroll interval for the announcement ticker (seconds)
  static const int announcementScrollInterval = 8;

  /// Page auto-rotate interval (seconds) — cycles through tabs
  static const int pageRotateInterval = 15;

  /// Date format used across the app
  static const String dateFormat = 'dd MMM yyyy';
}
