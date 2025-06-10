class MonthlyModel {
  final String id;
  final String userId;
  final String month;
  final String goalText;
  final String relatedFutureDiaryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  MonthlyModel({
    required this.id,
    required this.userId,
    required this.month,
    required this.goalText,
    required this.relatedFutureDiaryId,
    required this.createdAt,
    required this.updatedAt,
  });
}
