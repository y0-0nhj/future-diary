import 'dart:convert';

class DiaryModel {
  final String id;
  final String userId;
  final String occupation;
  final String pursuit;
  final int workHoursPerDay;
  final String workDaysPerWeek;
  final String monthlyBudget;
  final DateTime targetDate;
  final String weather;
  final String title;
  final String content;
  final String googleCalendarId;
  final Map<String, dynamic> projects; // '{"projectId": {"projectName": "projectName", "projectDescription": "projectDescription", "projectStartDate": "projectStartDate", "projectEndDate": "projectEndDate"}}'
  final Map<String, dynamic> unexpectedEvents; // '{"unexpectedEventId": {"unexpectedEventName": "unexpectedEventName", "unexpectedEventDescription": "unexpectedEventDescription", "unexpectedEventDate": "unexpectedEventDate", "unexpectedEventStatus": "unexpectedEventStatus"}}'
  final DateTime createdAt;
  final DateTime updatedAt;

  DiaryModel({
    required this.id,
    required this.userId,
    required this.occupation,
    required this.pursuit,
    required this.workHoursPerDay,
    required this.workDaysPerWeek,
    required this.monthlyBudget,
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