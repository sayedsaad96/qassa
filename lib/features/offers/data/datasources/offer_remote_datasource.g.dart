// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_remote_datasource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OfferModel _$OfferModelFromJson(Map<String, dynamic> json) => _OfferModel(
  id: json['id'] as String,
  requestId: json['request_id'] as String,
  factoryId: json['factory_id'] as String,
  factoryName: json['factory_name'] as String? ?? 'مصنع',
  factoryRating: (json['factory_rating'] as num?)?.toDouble() ?? 0.0,
  pricePerPiece: (json['price_per_piece'] as num).toDouble(),
  leadTimeDays: (json['lead_time_days'] as num).toInt(),
  notes: json['notes'] as String?,
  status: json['status'] as String? ?? 'pending',
  createdAt: DateTime.parse(json['created_at'] as String),
  quantity: (json['quantity'] as num?)?.toInt() ?? 0,
  productType: json['product_type'] as String? ?? '',
);

Map<String, dynamic> _$OfferModelToJson(_OfferModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'request_id': instance.requestId,
      'factory_id': instance.factoryId,
      'factory_name': instance.factoryName,
      'factory_rating': instance.factoryRating,
      'price_per_piece': instance.pricePerPiece,
      'lead_time_days': instance.leadTimeDays,
      'notes': instance.notes,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'quantity': instance.quantity,
      'product_type': instance.productType,
    };
