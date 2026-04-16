import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entity.freezed.dart';

// ════════════════════════════════════
// NOTIFICATION TYPES
// ════════════════════════════════════
enum NotificationType {
  offerReceived,    // Brand: new offer on your request
  offerAccepted,    // Factory: your offer was accepted
  offerRejected,    // Factory: your offer was rejected
  requestNew,       // Factory: new matching request
  general,          // System notification
}

// ════════════════════════════════════
// NOTIFICATION ENTITY
// ════════════════════════════════════
@freezed
abstract class NotificationEntity with _$NotificationEntity {
  const NotificationEntity._();

  const factory NotificationEntity({
    required String id,
    required String userId,
    required NotificationType type,
    required String title,
    required String body,
    String? relatedId,       // requestId or offerId
    String? relatedRoute,    // route to navigate to
    @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _NotificationEntity;

  String get typeIcon {
    switch (type) {
      case NotificationType.offerReceived:
        return '📩';
      case NotificationType.offerAccepted:
        return '✅';
      case NotificationType.offerRejected:
        return '❌';
      case NotificationType.requestNew:
        return '📋';
      case NotificationType.general:
        return '🔔';
    }
  }

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
    return '${createdAt.day}/${createdAt.month}';
  }
}
