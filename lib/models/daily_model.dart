class DailyModel {
  final String id;
  final String userId;
  final String planDate;
  final String title;
  final String description;
  final bool isCompleted;
  final String googleCalendarEventId;
  final String googleTasksTaskId;
  final String generatedByAI;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String color;

  DailyModel({
    required this.id,
    required this.userId,
    required this.planDate,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.googleCalendarEventId,
    required this.googleTasksTaskId,
    required this.generatedByAI,
    required this.createdAt,
    required this.updatedAt,
    required this.color,
  });
} 