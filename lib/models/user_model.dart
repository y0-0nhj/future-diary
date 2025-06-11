class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String gender;
  final String birth;
  final String country;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;


  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.gender,
    required this.birth,
    required this.country,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
  });
}
