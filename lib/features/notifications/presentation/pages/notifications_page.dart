import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../domain/entities/notification_entity.dart';
import '../cubit/notifications_cubit.dart';

// ════════════════════════════════════
// NOTIFICATIONS PAGE
// ════════════════════════════════════
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    unawaited(sl<NotificationsCubit>().loadNotifications());
    // Mark all as read after a short delay (user has "seen" the badge)
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) sl<NotificationsCubit>().markAllRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<NotificationsCubit>(),
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          title: const Text('الإشعارات'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => context.pop(),
          ),
          actions: [
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                final hasUnread = state is NotificationsLoaded &&
                    state.notifications.any((n) => !n.isRead);
                if (!hasUnread) return const SizedBox.shrink();
                return TextButton(
                  onPressed: () =>
                      sl<NotificationsCubit>().markAllRead(),
                  child: Text(
                    'قراءة الكل',
                    style: context.textStyles.bodySm.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: ResponsiveCenter(
          maxWidth: 700,
          child: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoading ||
                  state is NotificationsInitial) {
                return const AppLoading(message: 'جاري التحميل…');
              }
              if (state is NotificationsError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('😕', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 12),
                      Text(state.message, style: context.textStyles.bodySm),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'إعادة المحاولة',
                        onPressed: () =>
                            sl<NotificationsCubit>().loadNotifications(),
                        height: AppConstants.buttonHeightSm,
                      ),
                    ],
                  ),
                );
              }
              if (state is NotificationsLoaded) {
                if (state.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: context.colors.primaryPale,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child:
                                Text('🔔', style: TextStyle(fontSize: 36)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد إشعارات',
                          style: context.textStyles.h4.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'هنبعتلك تنبيه لما يكون في جديد',
                          style: context.textStyles.caption,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      sl<NotificationsCubit>().loadNotifications(),
                  color: context.colors.primary,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.spacingMd,
                    ),
                    itemCount: state.notifications.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, indent: 72),
                    itemBuilder: (context, i) {
                      final notif = state.notifications[i];
                      return _NotificationTile(
                        notification: notif,
                        onTap: () => _handleNotifTap(context, notif),
                      );
                    },
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  void _handleNotifTap(BuildContext context, NotificationEntity notif) {
    // Mark as read
    if (!notif.isRead) {
      sl<NotificationsCubit>().markAsRead(notif.id);
    }

    // Navigate if route is available
    if (notif.relatedRoute != null && notif.relatedRoute!.isNotEmpty) {
      context.push(notif.relatedRoute!);
    }
  }
}

// ════════════════════════════════════
// NOTIFICATION TILE
// ════════════════════════════════════
class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: isUnread
            ? context.colors.primaryPale.withValues(alpha: 0.5)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _iconBgColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  notification.typeIcon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: context.textStyles.label.copyWith(
                            fontWeight:
                                isUnread ? FontWeight.w800 : FontWeight.w600,
                            color: context.colors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notification.timeAgo,
                        style: context.textStyles.caption.copyWith(
                          fontSize: 10,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body,
                    style: context.textStyles.bodySm.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Unread dot
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6, right: 4),
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _iconBgColor(BuildContext context) {
    switch (notification.type) {
      case NotificationType.offerReceived:
        return context.colors.primaryPale;
      case NotificationType.offerAccepted:
        return context.colors.successBg;
      case NotificationType.offerRejected:
        return const Color(0xFFFEE2E2);
      case NotificationType.requestNew:
        return context.colors.accentPale;
      case NotificationType.general:
        return context.colors.background;
    }
  }
}
