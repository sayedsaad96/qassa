import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/widgets/app_asset_widgets.dart';
import '../../../brand/presentation/cubit/requests_cubit.dart';
import '../../../brand/domain/entities/entities.dart';
import '../../../brand/domain/usecases/get_request_by_id_usecase.dart';
import '../../../offers/presentation/cubit/offers_cubit.dart';
import '../../../offers/domain/entities/offer_entity.dart';

// ════════════════════════════════════
// FACTORY SHELL
// ════════════════════════════════════
class FactoryShellPage extends StatelessWidget {
  final StatefulNavigationShell shell;
  const FactoryShellPage({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _FactoryNavItem(index: 0, emoji: '📊', label: 'الرئيسية', current: shell.currentIndex, onTap: () => _go(0)),
                _FactoryNavItem(index: 1, emoji: '📋', label: 'الطلبات',  current: shell.currentIndex, onTap: () => _go(1)),
                _FactoryNavItem(index: 2, emoji: '📤', label: 'عروضي',    current: shell.currentIndex, onTap: () => _go(2)),
                _FactoryNavItem(index: 3, emoji: '👤', label: 'حسابي',    current: shell.currentIndex, onTap: () => _go(3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _go(int i) => shell.goBranch(i, initialLocation: i == shell.currentIndex);
}

class _FactoryNavItem extends StatelessWidget {
  final int index;
  final String emoji;
  final String label;
  final int current;
  final VoidCallback onTap;

  const _FactoryNavItem({
    required this.index,
    required this.emoji,
    required this.label,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 10,
                color: isActive ? AppColors.primary : AppColors.textDisabled,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 18 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      body: RefreshIndicator(
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
                  left: 16, right: 16, bottom: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_factoryName 🏭',
                          style: AppTextStyles.h4.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'مرحباً، $_ownerName 👋',
                          style: AppTextStyles.h2.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w900,
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
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text('🔔', style: TextStyle(fontSize: 20))),
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
                      StatCard(value: '$_availableRequests', label: 'طلب متاح'),
                      const SizedBox(width: 8),
                      StatCard(value: '$_sentOffers', label: 'عروض مرسلة', valueColor: AppColors.accent),
                      const SizedBox(width: 8),
                      StatCard(value: '$_acceptedOffers', label: 'مقبول', valueColor: AppColors.success),
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
                    badge: _availableRequests > 0 ? '$_availableRequests' : null,
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
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),

                  // Performance hint
                  if (_sentOffers > 0)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.successBg,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Text('📈', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'معدل قبول عروضك: ${_acceptanceRate.toStringAsFixed(0)}%${_acceptanceRate >= 32 ? ' · أعلى من متوسط المنصة (32%)' : ''}',
                              style: AppTextStyles.bodySm.copyWith(color: AppColors.success),
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
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 18))),
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
                    color: Colors.white, fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════
// FACTORY REQUESTS PAGE (P1: competition signal)
// ════════════════════════════════════
class FactoryRequestsPage extends StatefulWidget {
  const FactoryRequestsPage({super.key});

  @override
  State<FactoryRequestsPage> createState() => _FactoryRequestsPageState();
}

class _FactoryRequestsPageState extends State<FactoryRequestsPage> {
  String _activeFilter = 'الكل';
  final _filters = ['الكل', 'تيشيرت', 'جينز', 'فستان', 'هوودي'];

  @override
  void initState() {
    super.initState();
    unawaited(sl<RequestsCubit>().loadAllRequests());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<RequestsCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('الطلبات 📋'),
          actions: [
            IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () {}),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: _filters.map((f) => Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: AppChip(
                      label: f,
                      selected: _activeFilter == f,
                      onTap: () {
                        setState(() => _activeFilter = f);
                        sl<RequestsCubit>().loadAllRequests(
                          specialty: f == 'الكل' ? null : f,
                        );
                      },
                    ),
                  )).toList(),
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: BlocBuilder<RequestsCubit, RequestsState>(
                builder: (context, state) {
                  if (state is RequestsLoading) return const AppLoading();
                  if (state is RequestsError) {
                    return NetworkErrorWithIllustration(
                      onRetry: () => sl<RequestsCubit>().loadAllRequests(),
                    );
                  }
                  if (state is RequestsLoaded) {
                    if (state.requests.isEmpty) {
                      return const EmptyStateWithIllustration(
                        illustrationAsset: AppAssets.emptyRequests,
                        title: 'مفيش طلبات دلوقتي',
                        subtitle: 'هنبلغك فور ما يجي طلب يناسب تخصصك',
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async => sl<RequestsCubit>().loadAllRequests(),
                      color: AppColors.primary,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(AppConstants.spacingMd),
                        itemCount: state.requests.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _FactoryRequestCard(
                          request: state.requests[i],
                          onTap: () => context.push(
                            '${AppRoutes.factoryRequests}/${state.requests[i].id}',
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FactoryRequestCard extends StatelessWidget {
  final RequestEntity request;
  final VoidCallback onTap;
  const _FactoryRequestCard({required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isOpportunity = request.offerCount == 0;

    return AppCard(
      onTap: onTap,
      borderColor: AppColors.accent.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_typeEmoji(request.productType)} ${request.productType} | ${request.quantity} قطعة',
                      style: AppTextStyles.h5,
                    ),
                    Text(
                      '${request.material}${request.targetPricePerPiece != null ? ' · الميزانية: ~${request.targetPricePerPiece!.toStringAsFixed(0)} ج/ق' : ' · بدون سعر محدد'}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Text(request.timeAgo, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 8),
          // P1: Competition signal
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isOpportunity ? AppColors.successBg : AppColors.warningBg,
              borderRadius: BorderRadius.circular(AppConstants.radiusPill),
              border: Border.all(
                color: isOpportunity
                    ? AppColors.success.withValues(alpha: 0.25)
                    : AppColors.warning.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              request.competitionText,
              style: AppTextStyles.caption.copyWith(
                color: isOpportunity ? AppColors.success : AppColors.warning,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _typeEmoji(String t) {
    switch (t) {
      case 'تيشيرت': return '👕';
      case 'جينز': return '👖';
      case 'فستان': return '👗';
      case 'هوودي': return '🧥';
      default: return '📦';
    }
  }
}

// ════════════════════════════════════
// REQUEST DETAIL PAGE (P0: brand identity)
// ════════════════════════════════════
class RequestDetailPage extends StatefulWidget {
  final String requestId;
  const RequestDetailPage({super.key, required this.requestId});

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  RequestEntity? _request;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRequest();
  }

  Future<void> _loadRequest() async {
    try {
      final result = await sl<GetRequestByIdUseCase>().call(widget.requestId);
      result.fold(
        (error) {
          if (!mounted) return;
          setState(() {
            _error = error;
            _loading = false;
          });
        },
        (req) {
          if (!mounted) return;
          setState(() {
            _request = req;
            _loading = false;
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'حدث خطأ في تحميل الطلب';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: AppLoading());
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: NetworkErrorWithIllustration(onRetry: _loadRequest),
      );
    }
    final req = _request!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '#${req.requestNumber ?? req.id.substring(0, 8).toUpperCase()}',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.textSecondary,
            fontFamily: 'monospace',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // P0 FIX: Brand Identity Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryPale, Colors.white],
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(color: const Color(0xFFC7D5F8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '👤 صاحب الطلب',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.accent, AppColors.accentLight],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            req.brandAvatarInitial ?? req.brandName[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(req.brandName, style: AppTextStyles.h5),
                            Text('عضو على المنصة', style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.successBg,
                          borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                        ),
                        child: Text(
                          '✓ براند موثق',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Request details grid
            AppCard(
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.5,
                    children: [
                      _DetailTile(label: 'النوع', value: '${_emoji(req.productType)} ${req.productType}'),
                      _DetailTile(label: 'الكمية', value: '${req.quantity} قطعة'),
                      _DetailTile(
                        label: 'الخامة',
                        value: req.material,
                        valueColor: req.material != 'مش محدد' ? AppColors.primary : null,
                      ),
                      _DetailTile(
                        label: 'الميزانية',
                        value: req.targetPricePerPiece != null
                            ? '~${req.targetPricePerPiece!.toStringAsFixed(0)} ج/ق'
                            : 'غير محدد',
                        valueColor: req.targetPricePerPiece != null ? AppColors.success : null,
                      ),
                    ],
                  ),
                  if (req.notes != null && req.notes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ملاحظات', style: AppTextStyles.caption),
                          const SizedBox(height: 4),
                          Text(req.notes!, style: AppTextStyles.body),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            if (req.referenceImageUrl != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(color: const Color(0xFFC7D5F8)),
                ),
                child: const Center(
                  child: Text('📎 صورة مرجعية متاحة للعرض', style: TextStyle(color: AppColors.primary)),
                ),
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: AppButton(
          label: '📤 إرسال عرض ←',
          onPressed: () => context.push(
            '${AppRoutes.factoryRequests}/${widget.requestId}/send-offer',
          ),
        ),
      ),
    );
  }

  String _emoji(String t) {
    switch (t) {
      case 'تيشيرت': return '👕';
      case 'جينز': return '👖';
      case 'فستان': return '👗';
      case 'هوودي': return '🧥';
      default: return '📦';
    }
  }
}

class _DetailTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _DetailTile({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(
            value,
            style: AppTextStyles.label.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════
// SEND OFFER PAGE
// ════════════════════════════════════
class SendOfferPage extends StatefulWidget {
  final String requestId;
  const SendOfferPage({super.key, required this.requestId});

  @override
  State<SendOfferPage> createState() => _SendOfferPageState();
}

class _SendOfferPageState extends State<SendOfferPage> {
  final _formKey = GlobalKey<FormState>();
  final _priceCtrl = TextEditingController();
  final _leadCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _priceCtrl.dispose();
    _leadCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<OffersCubit>(),
      child: BlocListener<OffersCubit, OffersState>(
        listener: (context, state) {
          if (state is OfferSent) {
            context.pop();
            context.pop();
            AppSnackBar.showSuccess(context, '✅ اتبعت عرضك! هنبلغك لما صاحب البراند يرد');
          } else if (state is OffersError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            title: const Text('إرسال عرض'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => context.pop(),
            ),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Market context hint for factory
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.successBg,
                      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                      border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Text('💡', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'طلبات مشابهة على المنصة: 35–55 ج/قطعة — كن تنافسياً!',
                            style: AppTextStyles.caption.copyWith(color: AppColors.success),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text('سعرك للقطعة', style: AppTextStyles.label),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          hint: 'مثال: 38',
                          controller: _priceCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'ادخل السعر';
                            if (double.tryParse(v) == null) return 'سعر غير صحيح';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('جنيه / قطعة', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Text('مدة التنفيذ', style: AppTextStyles.label),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          hint: 'مثال: 18',
                          controller: _leadCtrl,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'ادخل مدة التنفيذ';
                            if (int.tryParse(v) == null) return 'قيمة غير صحيحة';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('يوم', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Text('ملاحظة', style: AppTextStyles.label),
                  Text('اختياري', style: AppTextStyles.caption),
                  const SizedBox(height: 6),
                  AppTextField(
                    hint: 'أي معلومات إضافية عن المصنع أو الخامات…',
                    controller: _notesCtrl,
                    maxLines: 3,
                    maxLength: 120,
                  ),
                  const SizedBox(height: 32),

                  BlocBuilder<OffersCubit, OffersState>(
                    builder: (context, state) {
                      return AppButton(
                        label: '📤 إرسال العرض',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            sl<OffersCubit>().sendOffer(
                              requestId: widget.requestId,
                              pricePerPiece: double.parse(_priceCtrl.text),
                              leadTimeDays: int.parse(_leadCtrl.text),
                              notes: _notesCtrl.text.trim().isEmpty
                                  ? null
                                  : _notesCtrl.text.trim(),
                            );
                          }
                        },
                        isLoading: state is OffersLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════
// FACTORY OFFERS PAGE
// ════════════════════════════════════
class FactoryOffersPage extends StatefulWidget {
  const FactoryOffersPage({super.key});

  @override
  State<FactoryOffersPage> createState() => _FactoryOffersPageState();
}

class _FactoryOffersPageState extends State<FactoryOffersPage> {
  @override
  void initState() {
    super.initState();
    unawaited(sl<OffersCubit>().loadMyOffers());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<OffersCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('عروضي 📤')),
        body: BlocBuilder<OffersCubit, OffersState>(
          builder: (context, state) {
            if (state is OffersLoading) return const AppLoading();
            if (state is OffersError) {
              return NetworkErrorWithIllustration(
                onRetry: () => sl<OffersCubit>().loadMyOffers(),
              );
            }
            if (state is OffersLoaded) {
              if (state.offers.isEmpty) {
                return EmptyStateWithIllustration(
                  illustrationAsset: AppAssets.emptyFactoryOffers,
                  title: 'لسه ماعندكش عروض',
                  subtitle: 'ابدأ بتصفح الطلبات وإرسال أول عرض',
                  ctaLabel: 'تصفح الطلبات',
                  onCta: () => context.go(AppRoutes.factoryRequests),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                itemCount: state.offers.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _FactoryOfferCard(offer: state.offers[i]),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _FactoryOfferCard extends StatelessWidget {
  final OfferEntity offer;
  const _FactoryOfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color statusColor;
    String statusLabel;

    switch (offer.status) {
      case OfferStatus.accepted:
        borderColor = AppColors.success;
        statusColor = AppColors.success;
        statusLabel = '✓ مقبول';
        break;
      case OfferStatus.rejected:
        borderColor = AppColors.border;
        statusColor = AppColors.textDisabled;
        statusLabel = '✕ مرفوض';
        break;
      default:
        borderColor = AppColors.warning.withValues(alpha: 0.4);
        statusColor = AppColors.warning;
        statusLabel = '⏳ انتظار';
    }

    return AppCard(
      borderColor: borderColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${offer.productType} — ${offer.quantity} قطعة',
                      style: AppTextStyles.h5,
                    ),
                    Text(
                      'عرض: ${offer.pricePerPiece.toStringAsFixed(0)} ج/قطعة · ${offer.leadTimeDays} يوم',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                ),
                child: Text(
                  statusLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(offer.timeAgo, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
