import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../notifications/presentation/widgets/notification_bell.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';

// ════════════════════════════════════
// FACTORY DASHBOARD (P2: stats only)
// ════════════════════════════════════
class FactoryDashboardPage extends StatefulWidget {
  const FactoryDashboardPage({super.key});

  @override
  State<FactoryDashboardPage> createState() => _FactoryDashboardPageState();
}

class _FactoryDashboardPageState extends State<FactoryDashboardPage> {
  String _factoryName = 'مصنعك';
  String _ownerName = 'Ahmed';
  int _availableRequests = 0;
  int _sentOffers = 0;
  int _acceptedOffers = 0;
  double _acceptanceRate = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
    sl<NotificationsCubit>().startPolling();
  }

  Future<void> _loadDashboard() async {
    final svc = sl<UserService>();
    if (svc.currentUserId == null) return;

    final name = await svc.displayName;
    final factory = await svc.factoryName;
    final stats = await svc.getFactoryStats();

    if (!mounted) return;

    final offered = stats['offers'] ?? 0;
    final accepted = stats['accepted'] ?? 0;

    setState(() {
      _ownerName = name.isEmpty ? 'Ahmed' : name;
      _factoryName = factory;
      _availableRequests = stats['requests'] ?? 0;
      _sentOffers = offered;
      _acceptedOffers = accepted;
      _acceptanceRate = offered == 0 ? 0 : (accepted / offered) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: ResponsiveCenter(
        maxWidth: 800,
        child: RefreshIndicator(
          onRefresh: _loadDashboard,
          color: context.colors.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [const Color(0xFF0D2260), context.colors.primary],
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 12,
                    left: 16,
                    right: 16,
                    bottom: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$_factoryName 🏭',
                            style: context.textStyles.h4.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'مرحباً، $_ownerName 👋',
                            style: context.textStyles.h2.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'آخر تحديث: الآن',
                            style: context.textStyles.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      const NotificationBell(),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Stats row (P2: stats only, no duplicate request list)
                    Row(
                      children: [
                        StatCard(
                          value: '$_availableRequests',
                          label: 'طلب متاح',
                        ),
                        const SizedBox(width: 8),
                        StatCard(
                          value: '$_sentOffers',
                          label: 'عروض مرسلة',
                          valueColor: context.colors.accent,
                        ),
                        const SizedBox(width: 8),
                        StatCard(
                          value: '$_acceptedOffers',
                          label: 'مقبول',
                          valueColor: context.colors.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Quick actions — no duplicate content
                    const SectionTitle(title: 'إجراءات سريعة'),
                    _QuickAction(
                      icon: '📋',
                      iconBg: context.colors.primaryPale,
                      title: 'تصفح الطلبات الجديدة',
                      subtitle: '$_availableRequests طلب يناسب تخصصك',
                      badge: _availableRequests > 0
                          ? '$_availableRequests'
                          : null,
                      badgeColor: context.colors.accent,
                      onTap: () => context.go(AppRoutes.factoryRequests),
                    ),
                    _QuickAction(
                      icon: '📤',
                      iconBg: context.colors.accentPale,
                      title: 'تابع عروضي',
                      subtitle: '$_sentOffers عروض مرسلة',
                      onTap: () => context.go(AppRoutes.factoryOffers),
                    ),
                    _QuickAction(
                      icon: '📊',
                      iconBg: context.colors.successBg,
                      title: 'تحديث بروفايل المصنع',
                      subtitle: 'صور جديدة تزيد فرصك في الطلبات',
                      onTap: () => context.go(AppRoutes.factoryProfileSetup),
                    ),
                    const SizedBox(height: 12),

                    // Performance hint
                    if (_sentOffers > 0)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.colors.successBg,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusMd,
                          ),
                          border: Border.all(
                            color: context.colors.success.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text('📈', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'معدل قبول عروضك: ${_acceptanceRate.toStringAsFixed(0)}%${_acceptanceRate >= 32 ? ' · أعلى من متوسط المنصة (32%)' : ''}',
                                style: context.textStyles.bodySm.copyWith(
                                  color: context.colors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.badge,
    this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textStyles.h5),
                  Text(subtitle, style: context.textStyles.caption),
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor ?? context.colors.primary,
                  borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                ),
                child: Text(
                  badge!,
                  style: context.textStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}