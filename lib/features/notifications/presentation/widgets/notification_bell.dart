import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../cubit/notifications_cubit.dart';

// ════════════════════════════════════
// NOTIFICATION BELL (reusable widget)
// ════════════════════════════════════
/// A bell icon with an animated badge showing unread notification count.
/// Works for both Brand and Factory users.
/// Usage:
/// ```dart
/// NotificationBell(color: Colors.white)
/// ```
class NotificationBell extends StatelessWidget {
  final Color color;
  final double size;

  const NotificationBell({
    super.key,
    this.color = Colors.white,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<NotificationsCubit>(),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final unreadCount = state is NotificationsLoaded
              ? state.unreadCount
              : 0;

          return GestureDetector(
            onTap: () => context.push('/notifications'),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Center(
                    child: Text('🔔', style: TextStyle(fontSize: 20)),
                  ),
                  // Badge
                  if (unreadCount > 0)
                    Positioned(
                      top: 2,
                      left: 2,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutBack,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: context.colors.primary,
                            width: 1.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x40EF4444),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            unreadCount > 99 ? '99+' : '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
