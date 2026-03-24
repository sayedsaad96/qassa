// ── Model ─────────────────────────────────────────────
class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? brandName;
  final String? phone;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.brandName,
    this.phone,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    email: json['email'] as String? ?? '',
    name: json['name'] as String,
    role: json['role'] as String,
    brandName: json['brand_name'] as String?,
    phone: json['phone'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'role': role,
    'brand_name': brandName,
    'phone': phone,
    'created_at': createdAt.toIso8601String(),
  };
}
