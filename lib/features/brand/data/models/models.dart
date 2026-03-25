import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/entities.dart';

part 'models.freezed.dart';
part 'models.g.dart';

// ════════════════════════════════════
// FACTORY MODEL
// ════════════════════════════════════
@freezed
abstract class FactoryModel with _$FactoryModel {
  const FactoryModel._();

  const factory FactoryModel({
    required String id,
    @JsonKey(name: 'owner_id') required String ownerId,
    required String name,
    required String city,
    @Default([]) List<String> specialties,
    @JsonKey(name: 'min_quantity') @Default(100) int minQuantity,
    @JsonKey(name: 'lead_time_days') @Default(21) int leadTimeDays,
    @Default(0.0) double rating,
    @JsonKey(name: 'review_count') @Default(0) int reviewCount,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
    @JsonKey(name: 'portfolio_images')
    @Default([])
    List<String> portfolioImages,
    @JsonKey(name: 'is_fast_responder') @Default(false) bool isFastResponder,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _FactoryModel;

  factory FactoryModel.fromJson(Map<String, dynamic> json) =>
      _$FactoryModelFromJson(json);

  FactoryEntity toEntity() => FactoryEntity(
    id: id,
    ownerId: ownerId,
    name: name,
    city: city,
    specialties: specialties,
    minQuantity: minQuantity,
    leadTimeDays: leadTimeDays,
    rating: rating,
    reviewCount: reviewCount,
    coverImageUrl: coverImageUrl,
    portfolioImages: portfolioImages,
    isFastResponder: isFastResponder,
    createdAt: createdAt,
  );
}

// ════════════════════════════════════
// REQUEST MODEL
// ════════════════════════════════════
@freezed
abstract class RequestModel with _$RequestModel {
  const RequestModel._();

  const factory RequestModel({
    required String id,
    @JsonKey(name: 'brand_id') required String brandId,
    @JsonKey(name: 'brand_name') @Default('براند') String brandName,
    @JsonKey(name: 'brand_avatar_initial') String? brandAvatarInitial,
    @JsonKey(name: 'product_type') required String productType,
    required int quantity,
    @Default('مش محدد') String material,
    @Default('medium') String quality,
    @JsonKey(name: 'target_price_per_piece') double? targetPricePerPiece,
    String? notes,
    @JsonKey(name: 'reference_image_url') String? referenceImageUrl,
    @Default('active') String status,
    @JsonKey(name: 'offer_count') @Default(0) int offerCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'request_number') String? requestNumber,
  }) = _RequestModel;

  factory RequestModel.fromJson(Map<String, dynamic> json) =>
      _$RequestModelFromJson(json);

  Map<String, dynamic> toInsertJson() {
    final json = toJson();
    // remove purely read-only or server-generated fields that aren't needed on insert
    json.remove('id');
    json.remove('created_at');
    json.remove('offer_count');
    json.remove('request_number');
    // Remove nulls so we don't accidentally update optional fields with null inserts
    return json..removeWhere((key, value) => value == null);
  }

  RequestEntity toEntity() {
    RequestStatus entityStatus;
    switch (status) {
      case 'completed':
        entityStatus = RequestStatus.completed;
        break;
      case 'cancelled':
        entityStatus = RequestStatus.cancelled;
        break;
      default:
        entityStatus = RequestStatus.active;
    }

    RequestQuality entityQuality;
    switch (quality) {
      case 'low':
        entityQuality = RequestQuality.low;
        break;
      case 'high':
        entityQuality = RequestQuality.high;
        break;
      default:
        entityQuality = RequestQuality.medium;
    }

    return RequestEntity(
      id: id,
      brandId: brandId,
      brandName: brandName,
      brandAvatarInitial: brandAvatarInitial,
      productType: productType,
      quantity: quantity,
      material: material,
      quality: entityQuality,
      targetPricePerPiece: targetPricePerPiece,
      notes: notes,
      referenceImageUrl: referenceImageUrl,
      status: entityStatus,
      offerCount: offerCount,
      createdAt: createdAt,
      requestNumber: requestNumber,
    );
  }
}
