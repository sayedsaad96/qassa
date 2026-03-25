import 'package:freezed_annotation/freezed_annotation.dart';

part 'offer_entity.freezed.dart';

enum OfferStatus { pending, accepted, rejected }

@freezed
abstract class OfferEntity with _$OfferEntity {
  const OfferEntity._();

  const factory OfferEntity({
    required String id,
    required String requestId,
    required String factoryId,
    required String factoryName,
    @Default(0.0) double factoryRating,
    required double pricePerPiece,
    required int leadTimeDays,
    String? notes,
    @Default(OfferStatus.pending) OfferStatus status,
    required DateTime createdAt,
    @Default(0) int quantity,
    @Default('') String productType,
  }) = _OfferEntity;

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
