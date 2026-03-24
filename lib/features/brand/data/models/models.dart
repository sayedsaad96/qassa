import '../../domain/entities/entities.dart';

// ════════════════════════════════════
// FACTORY MODEL
// ════════════════════════════════════
class FactoryModel {
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

  const FactoryModel({
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

  factory FactoryModel.fromJson(Map<String, dynamic> j) => FactoryModel(
        id: j['id'] as String,
        ownerId: j['owner_id'] as String,
        name: j['name'] as String,
        city: j['city'] as String,
        specialties: List<String>.from(j['specialties'] ?? []),
        minQuantity: (j['min_quantity'] as num?)?.toInt() ?? 100,
        leadTimeDays: (j['lead_time_days'] as num?)?.toInt() ?? 21,
        rating: (j['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: (j['review_count'] as num?)?.toInt() ?? 0,
        coverImageUrl: j['cover_image_url'] as String?,
        portfolioImages: List<String>.from(j['portfolio_images'] ?? []),
        isFastResponder: j['is_fast_responder'] as bool? ?? false,
        createdAt: DateTime.parse(
            j['created_at'] as String? ?? DateTime.now().toIso8601String()),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'owner_id': ownerId,
        'name': name,
        'city': city,
        'specialties': specialties,
        'min_quantity': minQuantity,
        'lead_time_days': leadTimeDays,
        'rating': rating,
        'review_count': reviewCount,
        'cover_image_url': coverImageUrl,
        'portfolio_images': portfolioImages,
        'is_fast_responder': isFastResponder,
      };

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
class RequestModel {
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
  final String status;
  final int offerCount;
  final DateTime createdAt;
  final String? requestNumber;

  const RequestModel({
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
    this.status = 'active',
    this.offerCount = 0,
    required this.createdAt,
    this.requestNumber,
  });

  factory RequestModel.fromJson(Map<String, dynamic> j) => RequestModel(
        id: j['id'] as String,
        brandId: j['brand_id'] as String,
        brandName: j['brand_name'] as String? ?? 'براند',
        brandAvatarInitial: j['brand_avatar_initial'] as String?,
        productType: j['product_type'] as String,
        quantity: (j['quantity'] as num).toInt(),
        material: j['material'] as String? ?? 'مش محدد',
        targetPricePerPiece: (j['target_price_per_piece'] as num?)?.toDouble(),
        notes: j['notes'] as String?,
        referenceImageUrl: j['reference_image_url'] as String?,
        status: j['status'] as String? ?? 'active',
        offerCount: (j['offer_count'] as num?)?.toInt() ?? 0,
        createdAt: DateTime.parse(
            j['created_at'] as String? ?? DateTime.now().toIso8601String()),
        requestNumber: j['request_number'] as String?,
      );

  Map<String, dynamic> toInsertJson() => {
        'brand_id': brandId,
        'brand_name': brandName,
        'brand_avatar_initial': brandAvatarInitial,
        'product_type': productType,
        'quantity': quantity,
        'material': material,
        if (targetPricePerPiece != null)
          'target_price_per_piece': targetPricePerPiece,
        if (notes != null) 'notes': notes,
        if (referenceImageUrl != null)
          'reference_image_url': referenceImageUrl,
        'status': status,
      };

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
    return RequestEntity(
      id: id,
      brandId: brandId,
      brandName: brandName,
      brandAvatarInitial: brandAvatarInitial,
      productType: productType,
      quantity: quantity,
      material: material,
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
