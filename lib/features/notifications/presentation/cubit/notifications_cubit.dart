import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';
import '../../data/datasources/notification_remote_datasource.dart';

// ════════════════════════════════════
// STATES
// ════════════════════════════════════
abstract class NotificationsState extends Equatable {
  const NotificationsState();
  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);
  @override
  List<Object?> get props => [message];
}

// ════════════════════════════════════
// CUBIT
// ════════════════════════════════════
class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRemoteDataSource _dataSource;
  final String? Function() _getUserId;
  Timer? _pollTimer;

  NotificationsCubit({
    required NotificationRemoteDataSource dataSource,
    required String? Function() getUserId,
  })  : _dataSource = dataSource,
        _getUserId = getUserId,
        super(NotificationsInitial());

  /// Load notifications list + unread count
  Future<void> loadNotifications() async {
    final userId = _getUserId();
    if (userId == null) return;

    emit(NotificationsLoading());
    try {
      final rawList = await _dataSource.getNotifications(userId);
      final notifications = rawList.map(mapNotification).toList();
      final unreadCount = notifications.where((n) => !n.isRead).length;

      emit(NotificationsLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationsError('حدث خطأ في تحميل الإشعارات'));
    }
  }

  /// Fetch only unread count (lightweight, for badge)
  Future<void> refreshUnreadCount() async {
    final userId = _getUserId();
    if (userId == null) return;

    try {
      final count = await _dataSource.getUnreadCount(userId);
      final current = state;
      if (current is NotificationsLoaded) {
        emit(NotificationsLoaded(
          notifications: current.notifications,
          unreadCount: count,
        ));
      } else {
        emit(NotificationsLoaded(
          notifications: const [],
          unreadCount: count,
        ));
      }
    } catch (_) {
      // silently fail — badge just won't update
    }
  }

  /// Mark all notifications as read
  Future<void> markAllRead() async {
    final userId = _getUserId();
    if (userId == null) return;

    try {
      await _dataSource.markAllAsRead(userId);
      final current = state;
      if (current is NotificationsLoaded) {
        final updated = current.notifications
            .map((n) => NotificationEntity(
                  id: n.id,
                  userId: n.userId,
                  type: n.type,
                  title: n.title,
                  body: n.body,
                  relatedId: n.relatedId,
                  relatedRoute: n.relatedRoute,
                  isRead: true,
                  createdAt: n.createdAt,
                ))
            .toList();
        emit(NotificationsLoaded(
          notifications: updated,
          unreadCount: 0,
        ));
      }
    } catch (_) {}
  }

  /// Mark single notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _dataSource.markAsRead(notificationId);
      final current = state;
      if (current is NotificationsLoaded) {
        final updated = current.notifications.map((n) {
          if (n.id == notificationId) {
            return NotificationEntity(
              id: n.id,
              userId: n.userId,
              type: n.type,
              title: n.title,
              body: n.body,
              relatedId: n.relatedId,
              relatedRoute: n.relatedRoute,
              isRead: true,
              createdAt: n.createdAt,
            );
          }
          return n;
        }).toList();
        final unread = updated.where((n) => !n.isRead).length;
        emit(NotificationsLoaded(
          notifications: updated,
          unreadCount: unread,
        ));
      }
    } catch (_) {}
  }

  /// Start polling for new notifications every 30 seconds
  void startPolling() {
    _pollTimer?.cancel();
    refreshUnreadCount();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => refreshUnreadCount(),
    );
  }

  /// Stop polling
  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}
