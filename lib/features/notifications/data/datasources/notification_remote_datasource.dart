import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/notification_entity.dart';

// ════════════════════════════════════
// NOTIFICATION DATASOURCE
// ════════════════════════════════════
abstract class NotificationRemoteDataSource {
  Future<List<Map<String, dynamic>>> getNotifications(String userId);
  Future<int> getUnreadCount(String userId);
  Future<void> markAllAsRead(String userId);
  Future<void> markAsRead(String notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final SupabaseClient _client;
  NotificationRemoteDataSourceImpl(this._client);

  @override
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    final data = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);
    return List<Map<String, dynamic>>.from(data);
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    final result = await _client
        .from('notifications')
        .select('id')
        .eq('user_id', userId)
        .eq('is_read', false)
        .count();
    return result.count;
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }
}

// ════════════════════════════════════
// MODEL MAPPER
// ════════════════════════════════════
NotificationEntity mapNotification(Map<String, dynamic> json) {
  return NotificationEntity(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    type: _parseType(json['type'] as String?),
    title: json['title'] as String? ?? '',
    body: json['body'] as String? ?? '',
    relatedId: json['related_id'] as String?,
    relatedRoute: json['related_route'] as String?,
    isRead: json['is_read'] as bool? ?? false,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}

NotificationType _parseType(String? raw) {
  switch (raw) {
    case 'offer_received':
      return NotificationType.offerReceived;
    case 'offer_accepted':
      return NotificationType.offerAccepted;
    case 'offer_rejected':
      return NotificationType.offerRejected;
    case 'request_new':
      return NotificationType.requestNew;
    default:
      return NotificationType.general;
  }
}
