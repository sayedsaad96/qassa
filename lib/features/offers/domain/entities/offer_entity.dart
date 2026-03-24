enum OfferStatus { pending, accepted, rejected }

class OfferEntity {
  final String id;
  final String requestId;
  final String factoryId;
  final String factoryName;
  final double factoryRating;
  final double pricePerPiece;
  final int leadTimeDays;
  final String? notes;
  final OfferStatus status;
  final DateTime createdAt;
  final int quantity;
  final String productType;

  const OfferEntity({
    required this.id,
    required this.requestId,
    required this.factoryId,
    required this.factoryName,
    this.factoryRating = 0.0,
    required this.pricePerPiece,
    required this.leadTimeDays,
    this.notes,
    this.status = OfferStatus.pending,
    required this.createdAt,
    this.quantity = 0,
    this.productType = '',
  });

  double get totalCost => pricePerPiece * quantity;

  String get totalFormatted {
    final t = totalCost;
    if (t == 0) return '—';
    return '${t.toStringAsFixed(0)} ج';
  }

  String get statusLabel {
    switch (status) {
      case OfferStatus.pending:
        return 'انتظار';
      case OfferStatus.accepted:
        return 'مقبول';
      case OfferStatus.rejected:
        return 'مرفوض';
    }
  }

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    return 'منذ ${diff.inDays} يوم';
  }
}
