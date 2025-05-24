// lib/models/user_model.dart

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      uid: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'huurder',
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name, 'role': role};
  }
}
