import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_asset_widgets.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/utils/app_responsive.dart';
import '../cubit/requests_cubit.dart';
import '../../domain/entities/entities.dart';

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({super.key});

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  String _activeTab = 'active';

  @override
  void initState() {
    super.initState();
    unawaited(sl<RequestsCubit>().loadMyRequests());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<RequestsCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('طلباتي 📋'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(46),
            child: Container(
              color: AppColors.surface,
              child: Row(
                children: [
                  _Tab(
                    label: 'نشط ●',
                    value: 'active',
                    activeTab: _activeTab,
                    onTap: () => _setTab('active'),
                  ),
                  _Tab(
                    label: 'مكتمل',
                    value: 'completed',
                    activeTab: _activeTab,
                    onTap: () => _setTab('completed'),
                  ),
                  _Tab(
                    label: 'ملغي',
                    value: 'cancelled',
                    activeTab: _activeTab,
                    onTap: () => _setTab('cancelled'),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(AppRoutes.createRequest),
          backgroundColor: AppColors.primary,
          elevation: 4,
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
        body: ResponsiveCenter(
          child: BlocBuilder<RequestsCubit, RequestsState>(
            builder: (context, state) {
              if (state is RequestsLoading) return const AppLoading();
              if (state is RequestsError) {
                return NetworkErrorWithIllustration(
                  onRetry: () => sl<RequestsCubit>().loadMyRequests(),
                );
              }
              if (state is RequestsLoaded) {
                if (state.requests.isEmpty) {
                  return EmptyStateWithIllustration(
                    illustrationAsset: AppAssets.emptyRequests,
                    title: 'لسه ماعندكش طلبات',
                    subtitle: 'ابدأ بإنشاء أول طلب تصنيع واستقبل عروض من مصانع',
                    ctaLabel: '+ إنشاء طلب',
                    onCta: () => context.push(AppRoutes.createRequest),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => sl<RequestsCubit>().loadMyRequests(),
                  color: AppColors.primary,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    itemCount: state.requests.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _RequestCard(
                      request: state.requests[i],
                      onTap: () => context.push(
                        '/brand/requests/${state.requests[i].id}/offers',
                      ),
                    ),
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

  void _setTab(String tab) {
    setState(() => _activeTab = tab);
    sl<RequestsCubit>().switchTab(tab);
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final String value;
  final String activeTab;
  final VoidCallback onTap;
  const _Tab({
    required this.label,
    required this.value,
    required this.activeTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = value == activeTab;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.label.copyWith(
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final RequestEntity request;
  final VoidCallback onTap;
  const _RequestCard({required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = request.status == RequestStatus.active;
    return AppCard(
      onTap: onTap,
      borderColor: isActive ? AppColors.accent : AppColors.border,
      borderWidth: isActive ? 1.5 : 1.0,
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
                      '${_typeEmoji(request.productType)} ${request.productType} — ${request.quantity} قطعة',
                      style: AppTextStyles.h5,
                    ),
                    Text(
                      '${request.material} · ${request.targetPricePerPiece != null ? 'السعر: ${request.targetPricePerPiece!.toStringAsFixed(0)} ج' : 'بدون سعر محدد'}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(request.timeAgo, style: AppTextStyles.caption),
                  if (request.requestNumber != null)
                    Text(
                      '#${request.requestNumber}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (request.offerCount > 0)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusPill,
                    ),
                  ),
                  child: Text(
                    '🔴 ${request.offerCount} عرض جديد',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warningBg,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusPill,
                    ),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '⚡ ${request.offerCount} مصانع ردت',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            )
          else
            Text(
              '⏳ لا يوجد عروض بعد',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textDisabled,
              ),
            ),
        ],
      ),
    );
  }

  String _typeEmoji(String type) {
    switch (type) {
      case 'تيشيرت':
        return '👕';
      case 'جينز':
        return '👖';
      case 'فستان':
        return '👗';
      case 'هوودي':
        return '🧥';
      case 'سبور':
        return '🩳';
      default:
        return '📦';
    }
  }
}
