import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/utils/app_responsive.dart';

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
      backgroundColor: AppColors.background,
      body: ResponsiveCenter(
        maxWidth: 800,
        child: RefreshIndicator(
          onRefresh: _loadDashboard,
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0D2260), AppColors.primary],
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
                            style: AppTextStyles.h4.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'مرحباً، $_ownerName 👋',
                            style: AppTextStyles.h2.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'آخر تحديث: الآن',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('🔔', style: TextStyle(fontSize: 20)),
                        ),
                      ),
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
                          valueColor: AppColors.accent,
                        ),
                        const SizedBox(width: 8),
                        StatCard(
                          value: '$_acceptedOffers',
                          label: 'مقبول',
                          valueColor: AppColors.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Quick actions — no duplicate content
                    const SectionTitle(title: 'إجراءات سريعة'),
                    _QuickAction(
                      icon: '📋',
                      iconBg: AppColors.primaryPale,
                      title: 'تصفح الطلبات الجديدة',
                      subtitle: '$_availableRequests طلب يناسب تخصصك',
                      badge: _availableRequests > 0
                          ? '$_availableRequests'
                          : null,
                      badgeColor: AppColors.accent,
                      onTap: () => context.go(AppRoutes.factoryRequests),
                    ),
                    _QuickAction(
                      icon: '📤',
                      iconBg: AppColors.accentPale,
                      title: 'تابع عروضي',
                      subtitle: '$_sentOffers عروض مرسلة',
                      onTap: () => context.go(AppRoutes.factoryOffers),
                    ),
                    _QuickAction(
                      icon: '📊',
                      iconBg: AppColors.successBg,
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
                          color: AppColors.successBg,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusMd,
                          ),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text('📈', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'معدل قبول عروضك: ${_acceptanceRate.toStringAsFixed(0)}%${_acceptanceRate >= 32 ? ' · أعلى من متوسط المنصة (32%)' : ''}',
                                style: AppTextStyles.bodySm.copyWith(
                                  color: AppColors.success,
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
                  Text(title, style: AppTextStyles.h5),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor ?? AppColors.primary,
                  borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                ),
                child: Text(
                  badge!,
                  style: AppTextStyles.caption.copyWith(
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
