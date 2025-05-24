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
    String safeString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      return value.toString(); // fallback, just in case
    }

    return UserModel(
      uid: id,
      email: safeString(map['email']),
      name: safeString(map['name']),
      role:
          safeString(map['role']).isEmpty
              ? 'customer'
              : safeString(map['role']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name, 'role': role};
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, name: $name, role: $role)';
  }
}
