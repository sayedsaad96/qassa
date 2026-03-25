import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/factory_profile_entity.dart';

part 'factory_profile_model.freezed.dart';
part 'factory_profile_model.g.dart';

@freezed
abstract class FactoryProfileModel with _$FactoryProfileModel {
  const FactoryProfileModel._();

  const factory FactoryProfileModel({
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
  }) = _FactoryProfileModel;

  factory FactoryProfileModel.fromJson(Map<String, dynamic> json) =>
      _$FactoryProfileModelFromJson(json);

  factory FactoryProfileModel.fromEntity(FactoryProfileEntity e) =>
      FactoryProfileModel(
        id: e.id,
        ownerId: e.ownerId,
        name: e.name,
        city: e.city,
        specialties: e.specialties,
        minQuantity: e.minQuantity,
        leadTimeDays: e.leadTimeDays,
        rating: e.rating,
        reviewCount: e.reviewCount,
        coverImageUrl: e.coverImageUrl,
        portfolioImages: e.portfolioImages,
        isFastResponder: e.isFastResponder,
      );

  FactoryProfileEntity toEntity() => FactoryProfileEntity(
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
  );
}
