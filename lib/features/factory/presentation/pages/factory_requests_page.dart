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
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/widgets/app_asset_widgets.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../brand/presentation/cubit/requests_cubit.dart';
import '../../../brand/domain/entities/entities.dart';

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
        body: ResponsiveCenter(
          child: Column(
            children: [
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: _filters
                        .map(
                          (f) => Padding(
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
                          ),
                        )
                        .toList(),
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
                        onRefresh: () async =>
                            sl<RequestsCubit>().loadAllRequests(),
                        color: AppColors.primary,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(AppConstants.spacingMd),
                          itemCount: state.requests.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
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
          // P1: Competition signal & Quality badge
          Wrap(
            spacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isOpportunity
                      ? AppColors.successBg
                      : AppColors.warningBg,
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
                    color: isOpportunity
                        ? AppColors.success
                        : AppColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  request.qualityLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: request.quality == RequestQuality.high
                        ? Colors.orange
                        : request.quality == RequestQuality.low
                        ? AppColors.textSecondary
                        : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _typeEmoji(String t) {
    switch (t) {
      case 'تيشيرت':
        return '👕';
      case 'جينز':
        return '👖';
      case 'فستان':
        return '👗';
      case 'هوودي':
        return '🧥';
      default:
        return '📦';
    }
  }
}
