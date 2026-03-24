// ══════════════════════════════════════════════════════════
// ENTITY
// ══════════════════════════════════════════════════════════
class UserEntity {
  final String id;
  final String email;
  final String name;
  final String role; // 'brand' | 'factory'
  final String? brandName;
  final String? phone;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.brandName,
    this.phone,
    required this.createdAt,
  });

  bool get isBrand => role == 'brand';
  bool get isFactory => role == 'factory';
}
