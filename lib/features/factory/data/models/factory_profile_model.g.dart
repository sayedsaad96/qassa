// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factory_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FactoryProfileModel _$FactoryProfileModelFromJson(Map<String, dynamic> json) =>
    _FactoryProfileModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      specialties:
          (json['specialties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      minQuantity: (json['min_quantity'] as num?)?.toInt() ?? 100,
      leadTimeDays: (json['lead_time_days'] as num?)?.toInt() ?? 21,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      coverImageUrl: json['cover_image_url'] as String?,
      portfolioImages:
          (json['portfolio_images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isFastResponder: json['is_fast_responder'] as bool? ?? false,
    );

Map<String, dynamic> _$FactoryProfileModelToJson(
  _FactoryProfileModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'owner_id': instance.ownerId,
  'name': instance.name,
  'city': instance.city,
  'specialties': instance.specialties,
  'min_quantity': instance.minQuantity,
  'lead_time_days': instance.leadTimeDays,
  'rating': instance.rating,
  'review_count': instance.reviewCount,
  'cover_image_url': instance.coverImageUrl,
  'portfolio_images': instance.portfolioImages,
  'is_fast_responder': instance.isFastResponder,
};
