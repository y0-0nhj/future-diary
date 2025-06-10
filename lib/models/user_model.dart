class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String gender;
  final String birth;
  final String country;
  final String occupation;
  final String pursuit;
  final int workHoursPerDay;
  final int workDaysPerWeek;
  final int monthlyBudget;
  final DateTime createdAt;
  final DateTime updatedAt;


  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.gender,
    required this.birth,
    required this.country,
    required this.occupation,
    required this.pursuit,
    required this.workHoursPerDay,
    required this.workDaysPerWeek,
    required this.monthlyBudget,
    required this.createdAt,
    required this.updatedAt,
  });
}
