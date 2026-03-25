// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FactoryModel _$FactoryModelFromJson(Map<String, dynamic> json) =>
    _FactoryModel(
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
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$FactoryModelToJson(_FactoryModel instance) =>
    <String, dynamic>{
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
      'created_at': instance.createdAt.toIso8601String(),
    };

_RequestModel _$RequestModelFromJson(Map<String, dynamic> json) =>
    _RequestModel(
      id: json['id'] as String,
      brandId: json['brand_id'] as String,
      brandName: json['brand_name'] as String? ?? 'براند',
      brandAvatarInitial: json['brand_avatar_initial'] as String?,
      productType: json['product_type'] as String,
      quantity: (json['quantity'] as num).toInt(),
      material: json['material'] as String? ?? 'مش محدد',
      quality: json['quality'] as String? ?? 'medium',
      targetPricePerPiece: (json['target_price_per_piece'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      referenceImageUrl: json['reference_image_url'] as String?,
      status: json['status'] as String? ?? 'active',
      offerCount: (json['offer_count'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      requestNumber: json['request_number'] as String?,
    );

Map<String, dynamic> _$RequestModelToJson(_RequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brand_id': instance.brandId,
      'brand_name': instance.brandName,
      'brand_avatar_initial': instance.brandAvatarInitial,
      'product_type': instance.productType,
      'quantity': instance.quantity,
      'material': instance.material,
      'quality': instance.quality,
      'target_price_per_piece': instance.targetPricePerPiece,
      'notes': instance.notes,
      'reference_image_url': instance.referenceImageUrl,
      'status': instance.status,
      'offer_count': instance.offerCount,
      'created_at': instance.createdAt.toIso8601String(),
      'request_number': instance.requestNumber,
    };
