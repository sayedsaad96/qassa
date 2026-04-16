import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/widgets/app_asset_widgets.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../brand/presentation/cubit/requests_cubit.dart';
import '../../../brand/domain/entities/entities.dart';

// ════════════════════════════════════
// FACTORY REQUESTS PAGE
// ════════════════════════════════════
class FactoryRequestsPage extends StatefulWidget {
  const FactoryRequestsPage({super.key});

  @override
  State<FactoryRequestsPage> createState() => _FactoryRequestsPageState();
}

class _FactoryRequestsPageState extends State<FactoryRequestsPage> {
  String _activeCategory = 'الكل';

  // Filter state
  String? _filterQuality;
  String? _filterSortBy;
  RangeValues _quantityRange = const RangeValues(0, 5000);
  bool _noOffersOnly = false;
  int _activeFilterCount = 0;

  final _categories = ['الكل', 'تيشيرت', 'جينز', 'فستان', 'هوودي', 'قميص', 'بنطلون', 'جاكيت'];

  @override
  void initState() {
    super.initState();
    unawaited(sl<RequestsCubit>().loadAllRequests());
  }

  List<RequestEntity> _applyFilters(List<RequestEntity> requests) {
    var filtered = List<RequestEntity>.from(requests);

    // Filter by quality
    if (_filterQuality != null) {
      final q = _parseQuality(_filterQuality!);
      if (q != null) {
        filtered = filtered.where((r) => r.quality == q).toList();
      }
    }

    // Filter by quantity range
    filtered = filtered
        .where((r) =>
            r.quantity >= _quantityRange.start &&
            r.quantity <= _quantityRange.end)
        .toList();

    // No offers only
    if (_noOffersOnly) {
      filtered = filtered.where((r) => r.offerCount == 0).toList();
    }

    // Sort
    if (_filterSortBy == 'الأحدث') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (_filterSortBy == 'الأعلى كمية') {
      filtered.sort((a, b) => b.quantity.compareTo(a.quantity));
    } else if (_filterSortBy == 'أقل منافسة') {
      filtered.sort((a, b) => a.offerCount.compareTo(b.offerCount));
    } else if (_filterSortBy == 'الأعلى سعراً') {
      filtered.sort((a, b) {
        final ap = a.targetPricePerPiece ?? 0;
        final bp = b.targetPricePerPiece ?? 0;
        return bp.compareTo(ap);
      });
    }

    return filtered;
  }

  RequestQuality? _parseQuality(String label) {
    switch (label) {
      case 'جودة عالية':
        return RequestQuality.high;
      case 'جودة متوسطة':
        return RequestQuality.medium;
      case 'جودة اقتصادية':
        return RequestQuality.low;
      default:
        return null;
    }
  }

  void _countActiveFilters() {
    int count = 0;
    if (_filterQuality != null) count++;
    if (_filterSortBy != null) count++;
    if (_quantityRange.start > 0 || _quantityRange.end < 5000) count++;
    if (_noOffersOnly) count++;
    setState(() => _activeFilterCount = count);
  }

  void _showFilterSheet() {
    // Local copies for the bottom sheet
    String? tempQuality = _filterQuality;
    String? tempSortBy = _filterSortBy;
    RangeValues tempQuantity = _quantityRange;
    bool tempNoOffers = _noOffersOnly;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppConstants.radiusXl),
              ),
            ),
            padding: EdgeInsets.only(
              top: 12,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.colors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('فلتر الطلبات 🔍', style: context.textStyles.h4),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempQuality = null;
                            tempSortBy = null;
                            tempQuantity = const RangeValues(0, 5000);
                            tempNoOffers = false;
                          });
                        },
                        child: Text(
                          'مسح الكل',
                          style: context.textStyles.bodySm.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Sort By ──
                  Text('ترتيب حسب', style: context.textStyles.label),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['الأحدث', 'الأعلى كمية', 'أقل منافسة', 'الأعلى سعراً']
                        .map(
                          (s) => AppChip(
                            label: s,
                            selected: tempSortBy == s,
                            onTap: () => setModalState(
                              () => tempSortBy = tempSortBy == s ? null : s,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  // ── Quality ──
                  Text('مستوى الجودة', style: context.textStyles.label),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['جودة عالية', 'جودة متوسطة', 'جودة اقتصادية']
                        .map(
                          (q) => AppChip(
                            label: q,
                            selected: tempQuality == q,
                            onTap: () => setModalState(
                              () => tempQuality = tempQuality == q ? null : q,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  // ── Quantity Range ──
                  Text(
                    'الكمية: ${tempQuantity.start.toInt()} - ${tempQuantity.end.toInt()} قطعة',
                    style: context.textStyles.label,
                  ),
                  const SizedBox(height: 4),
                  RangeSlider(
                    values: tempQuantity,
                    min: 0,
                    max: 5000,
                    divisions: 50,
                    activeColor: context.colors.primary,
                    labels: RangeLabels(
                      '${tempQuantity.start.toInt()}',
                      '${tempQuantity.end.toInt()}',
                    ),
                    onChanged: (v) => setModalState(() => tempQuantity = v),
                  ),
                  const SizedBox(height: 12),

                  // ── No offers toggle ──
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'الطلبات بدون عروض فقط 🔔',
                      style: context.textStyles.body,
                    ),
                    subtitle: Text(
                      'فرصتك الذهبية — كن أول من يُقدّم عرض',
                      style: context.textStyles.caption,
                    ),
                    value: tempNoOffers,
                    activeThumbColor: context.colors.primary,
                    onChanged: (v) => setModalState(() => tempNoOffers = v),
                  ),
                  const SizedBox(height: 20),

                  // ── Apply ──
                  AppButton(
                    label: 'تطبيق الفلتر',
                    onPressed: () {
                      setState(() {
                        _filterQuality = tempQuality;
                        _filterSortBy = tempSortBy;
                        _quantityRange = tempQuantity;
                        _noOffersOnly = tempNoOffers;
                      });
                      _countActiveFilters();
                      Navigator.pop(ctx);
                    },
                    height: AppConstants.buttonHeight,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<RequestsCubit>(),
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          title: const Text('الطلبات 📋'),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: _showFilterSheet,
                ),
                if (_activeFilterCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          '$_activeFilterCount',
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
          ],
        ),
        body: ResponsiveCenter(
          child: Column(
            children: [
              // Category chips
              Container(
                color: context.colors.surface,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: _categories
                        .map(
                          (f) => Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: AppChip(
                              label: f,
                              selected: _activeCategory == f,
                              onTap: () {
                                setState(() => _activeCategory = f);
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
                      final filtered = _applyFilters(state.requests);

                      if (state.requests.isEmpty) {
                        return const EmptyStateWithIllustration(
                          illustrationAsset: AppAssets.emptyRequests,
                          title: 'مفيش طلبات دلوقتي',
                          subtitle: 'هنبلغك فور ما يجي طلب يناسب تخصصك',
                        );
                      }

                      if (filtered.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🔍', style: TextStyle(fontSize: 40)),
                              const SizedBox(height: 12),
                              Text(
                                'لا توجد طلبات مطابقة للفلتر',
                                style: context.textStyles.h5.copyWith(
                                  color: context.colors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _filterQuality = null;
                                    _filterSortBy = null;
                                    _quantityRange = const RangeValues(0, 5000);
                                    _noOffersOnly = false;
                                    _activeFilterCount = 0;
                                  });
                                },
                                child: const Text('مسح الفلاتر'),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async =>
                            sl<RequestsCubit>().loadAllRequests(
                          specialty:
                              _activeCategory == 'الكل' ? null : _activeCategory,
                        ),
                        color: context.colors.primary,
                        child: ListView.separated(
                          padding:
                              const EdgeInsets.all(AppConstants.spacingMd),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, i) => _FactoryRequestCard(
                            request: filtered[i],
                            onTap: () => context.push(
                              '${AppRoutes.factoryRequests}/${filtered[i].id}',
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

// ════════════════════════════════════
// REQUEST CARD (redesigned)
// ════════════════════════════════════
class _FactoryRequestCard extends StatelessWidget {
  final RequestEntity request;
  final VoidCallback onTap;
  const _FactoryRequestCard({required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isOpportunity = request.offerCount == 0;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Product type + time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: context.colors.primaryPale,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _typeEmoji(request.productType),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${request.productType} — ${request.quantity} قطعة',
                      style: context.textStyles.h5,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'خامة: ${request.material}',
                      style: context.textStyles.caption,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                  border: Border.all(color: context.colors.border),
                ),
                child: Text(
                  request.timeAgo,
                  style: context.textStyles.caption.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Info chips
          Row(
            children: [
              // Budget
              if (request.targetPricePerPiece != null)
                _InfoChip(
                  icon: '💰',
                  label: '${request.targetPricePerPiece!.toStringAsFixed(0)} ج/ق',
                ),
              if (request.targetPricePerPiece != null) const SizedBox(width: 8),

              // Brand name
              _InfoChip(
                icon: '🏷',
                label: request.brandName,
              ),
              const SizedBox(width: 8),

              // Quality
              _InfoChip(
                icon: request.quality == RequestQuality.high
                    ? '🌟'
                    : request.quality == RequestQuality.low
                        ? '📉'
                        : '⭐',
                label: request.quality == RequestQuality.high
                    ? 'عالية'
                    : request.quality == RequestQuality.low
                        ? 'اقتصادية'
                        : 'متوسطة',
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 3: Competition signal
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isOpportunity ? context.colors.successBg : context.colors.warningBg,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isOpportunity
                    ? context.colors.success.withValues(alpha: 0.2)
                    : context.colors.warning.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Text(
                  isOpportunity ? '🟢' : '🟡',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    request.competitionText,
                    style: context.textStyles.caption.copyWith(
                      color:
                          isOpportunity ? context.colors.success : context.colors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color:
                      isOpportunity ? context.colors.success : context.colors.warning,
                ),
              ],
            ),
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
      case 'قميص':
        return '👔';
      case 'بنطلون':
        return '👖';
      case 'جاكيت':
        return '🧥';
      default:
        return '📦';
    }
  }
}

// ════════════════════════════════════
// SMALL INFO CHIP
// ════════════════════════════════════
class _InfoChip extends StatelessWidget {
  final String icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusPill),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 4),
          Text(
            label,
            style: context.textStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}