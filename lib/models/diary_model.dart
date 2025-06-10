class DiaryModel {
  final String id;
  final String userId;
  final DateTime targetDate;
  final String weather;
  final String title;
  final String content;
  final String googleCalendarId;
  final String projects;
  final String unexpectedEvents;
  final DateTime createdAt;
  final DateTime updatedAt;

  DiaryModel({
    required this.id,
    required this.userId,
    required this.targetDate,
    required this.weather,
    required this.title,
    required this.content,
    required this.googleCalendarId,
    required this.projects,
    required this.unexpectedEvents,
    required this.createdAt,
    required this.updatedAt,
  });
} 