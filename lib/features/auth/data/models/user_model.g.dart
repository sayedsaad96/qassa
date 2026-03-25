// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String? ?? '',
  name: json['name'] as String,
  role: json['role'] as String,
  brandName: json['brand_name'] as String?,
  phone: json['phone'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': instance.role,
      'brand_name': instance.brandName,
      'phone': instance.phone,
      'created_at': instance.createdAt.toIso8601String(),
    };
