import 'package:freezed_annotation/freezed_annotation.dart';

part 'factory_profile_entity.freezed.dart';

@freezed
abstract class FactoryProfileEntity with _$FactoryProfileEntity {
  const factory FactoryProfileEntity({
    required String id,
    required String ownerId,
    required String name,
    required String city,
    required List<String> specialties,
    required int minQuantity,
    required int leadTimeDays,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    String? coverImageUrl,
    @Default([]) List<String> portfolioImages,
    @Default(false) bool isFastResponder,
  }) = _FactoryProfileEntity;
}
