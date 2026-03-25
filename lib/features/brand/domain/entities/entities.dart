import 'package:freezed_annotation/freezed_annotation.dart';

part 'entities.freezed.dart';

// ════════════════════════════════════
// FACTORY ENTITY
// ════════════════════════════════════
@freezed
abstract class FactoryEntity with _$FactoryEntity {
  const FactoryEntity._();

  const factory FactoryEntity({
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
    required DateTime createdAt,
  }) = _FactoryEntity;

  String get ratingFormatted => rating.toStringAsFixed(1);
  String get specialtiesStr => specialties.join(' · ');
}

// ════════════════════════════════════
// REQUEST ENTITY
// ════════════════════════════════════
enum RequestStatus { active, completed, cancelled }

enum RequestQuality { low, medium, high }

@freezed
abstract class RequestEntity with _$RequestEntity {
  const RequestEntity._();

  const factory RequestEntity({
    required String id,
    required String brandId,
    required String brandName,
    String? brandAvatarInitial,
    required String productType,
    required int quantity,
    @Default('مش محدد') String material,
    @Default(RequestQuality.medium) RequestQuality quality,
    double? targetPricePerPiece,
    String? notes,
    String? referenceImageUrl,
    @Default(RequestStatus.active) RequestStatus status,
    @Default(0) int offerCount,
    required DateTime createdAt,
    String? requestNumber,
  }) = _RequestEntity;

  String get statusLabel {
    switch (status) {
      case RequestStatus.active:
        return 'نشط';
      case RequestStatus.completed:
        return 'مكتمل';
      case RequestStatus.cancelled:
        return 'ملغي';
    }
  }

  String get qualityLabel {
    switch (quality) {
      case RequestQuality.high:
        return 'جودة عالية 🌟';
      case RequestQuality.medium:
        return 'جودة متوسطة ⭐';
      case RequestQuality.low:
        return 'جودة اقتصادية 📉';
    }
  }

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    return 'منذ ${diff.inDays} يوم';
  }

  String get competitionText {
    if (offerCount == 0) return '🔔 لسه مفيش عروض — فرصة!';
    if (offerCount == 1) return '⚡ مصنع واحد بعت عرض بالفعل';
    if (offerCount <= 3) return '⚡ $offerCount مصانع بعتوا عروض — كن الأول!';
    return '⚡ $offerCount مصانع بعتوا عروض';
  }
}
