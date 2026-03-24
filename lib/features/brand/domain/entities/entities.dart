// ════════════════════════════════════
// FACTORY ENTITY
// ════════════════════════════════════
class FactoryEntity {
  final String id;
  final String ownerId;
  final String name;
  final String city;
  final List<String> specialties;
  final int minQuantity;
  final int leadTimeDays;
  final double rating;
  final int reviewCount;
  final String? coverImageUrl;
  final List<String> portfolioImages;
  final bool isFastResponder;
  final DateTime createdAt;

  const FactoryEntity({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.city,
    required this.specialties,
    required this.minQuantity,
    required this.leadTimeDays,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.coverImageUrl,
    this.portfolioImages = const [],
    this.isFastResponder = false,
    required this.createdAt,
  });

  String get ratingFormatted => rating.toStringAsFixed(1);
  String get specialtiesStr => specialties.join(' · ');
}

// ════════════════════════════════════
// REQUEST ENTITY
// ════════════════════════════════════
enum RequestStatus { active, completed, cancelled }

class RequestEntity {
  final String id;
  final String brandId;
  final String brandName;
  final String? brandAvatarInitial;
  final String productType;
  final int quantity;
  final String material;
  final double? targetPricePerPiece;
  final String? notes;
  final String? referenceImageUrl;
  final RequestStatus status;
  final int offerCount;
  final DateTime createdAt;
  final String? requestNumber;

  const RequestEntity({
    required this.id,
    required this.brandId,
    required this.brandName,
    this.brandAvatarInitial,
    required this.productType,
    required this.quantity,
    this.material = 'مش محدد',
    this.targetPricePerPiece,
    this.notes,
    this.referenceImageUrl,
    this.status = RequestStatus.active,
    this.offerCount = 0,
    required this.createdAt,
    this.requestNumber,
  });

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

