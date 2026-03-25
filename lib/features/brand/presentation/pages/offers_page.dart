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
import '../../../offers/presentation/cubit/offers_cubit.dart';
import '../../../offers/domain/entities/offer_entity.dart';

// ════════════════════════════════════
// OFFERS PAGE
// ════════════════════════════════════
class OffersPage extends StatefulWidget {
  final String requestId;
  const OffersPage({super.key, required this.requestId});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  bool _isComparisonMode = false;
  @override
  void initState() {
    super.initState();
    unawaited(sl<OffersCubit>().loadOffers(widget.requestId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<OffersCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('العروض'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: ResponsiveCenter(
          child: BlocBuilder<OffersCubit, OffersState>(
            builder: (context, state) {
              if (state is OffersLoading) return const AppLoading();
              if (state is OffersError) {
                return NetworkErrorWithIllustration(
                  onRetry: () => sl<OffersCubit>().loadOffers(widget.requestId),
                );
              }
              if (state is OffersLoaded) {
                if (state.offers.isEmpty) {
                  return const EmptyStateWithIllustration(
                    illustrationAsset: AppAssets.emptyOffers,
                    title: 'العروض في الطريق',
                    subtitle: 'بعتنا طلبك للمصانع المناسبة، استنى شوية',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async =>
                      sl<OffersCubit>().loadOffers(widget.requestId),
                  color: AppColors.primary,
                  child: ListView(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${state.offers.length} عروض وصلتك',
                            style: AppTextStyles.h4,
                          ),
                          if (state.offers.length > 1)
                            TextButton.icon(
                              onPressed: () => setState(
                                () => _isComparisonMode = !_isComparisonMode,
                              ),
                              icon: Icon(
                                _isComparisonMode
                                    ? Icons.list
                                    : Icons.compare_arrows,
                              ),
                              label: Text(
                                _isComparisonMode
                                    ? 'عرض عادي'
                                    : 'مقارنة العروض',
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_isComparisonMode)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: state.offers.asMap().entries.map((entry) {
                              final i = entry.key;
                              final offer = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: i == state.offers.length - 1 ? 0 : 12,
                                ),
                                child: _ComparisonCard(
                                  offer: offer,
                                  isBestPrice:
                                      i == _bestPriceIndex(state.offers),
                                  isFastest: i == _fastestIndex(state.offers),
                                  onAccept: () => context.push(
                                    '/brand/requests/${widget.requestId}/offers/${offer.id}/summary',
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      else
                        ...state.offers.asMap().entries.map((entry) {
                          final i = entry.key;
                          final offer = entry.value;
                          final isBestPrice =
                              i == _bestPriceIndex(state.offers);
                          final isFastest = i == _fastestIndex(state.offers);
                          return _OfferCard(
                            offer: offer,
                            isBestPrice: isBestPrice,
                            isFastest: isFastest,
                            onAccept: () => context.push(
                              '/brand/requests/${widget.requestId}/offers/${offer.id}/summary',
                            ),
                          );
                        }),
                    ],
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

  int _bestPriceIndex(List<OfferEntity> offers) {
    if (offers.isEmpty) return -1;
    var minIdx = 0;
    for (var i = 1; i < offers.length; i++) {
      if (offers[i].pricePerPiece < offers[minIdx].pricePerPiece) minIdx = i;
    }
    return minIdx;
  }

  int _fastestIndex(List<OfferEntity> offers) {
    if (offers.isEmpty) return -1;
    var minIdx = 0;
    for (var i = 1; i < offers.length; i++) {
      if (offers[i].leadTimeDays < offers[minIdx].leadTimeDays) minIdx = i;
    }
    return _bestPriceIndex(offers) == minIdx ? -1 : minIdx;
  }
}

class _ComparisonCard extends StatelessWidget {
  final OfferEntity offer;
  final bool isBestPrice;
  final bool isFastest;
  final VoidCallback onAccept;

  const _ComparisonCard({
    required this.offer,
    required this.isBestPrice,
    required this.isFastest,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.border;
    if (isBestPrice) borderColor = AppColors.accent;
    if (isFastest) borderColor = AppColors.primary;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: borderColor,
          width: (isBestPrice || isFastest) ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  offer.factoryName,
                  style: AppTextStyles.h5,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '★ ${offer.factoryRating.toStringAsFixed(1)}',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFFF59E0B),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (isBestPrice || isFastest) ...[
            const SizedBox(height: 6),
            if (isBestPrice)
              _Badge(
                label: '🏆 أفضل سعر',
                gradient: [AppColors.accent, AppColors.accentLight],
              ),
            if (isFastest)
              _Badge(
                label: '⚡ أسرع تسليم',
                gradient: [AppColors.primary, AppColors.primaryLight],
              ),
          ],
          const Divider(height: 24),
          _ComparisonRow(
            label: 'السعر للقطعة',
            value: '${offer.pricePerPiece.toStringAsFixed(0)} ج',
            valueColor: AppColors.primary,
          ),
          _ComparisonRow(
            label: 'مدة التسليم',
            value: '${offer.leadTimeDays} يوم',
          ),
          if (offer.quantity > 0)
            _ComparisonRow(
              label: 'الإجمالي (تقريبي)',
              value: offer.totalFormatted,
            ),
          if (offer.notes != null && offer.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('ملاحظات:', style: AppTextStyles.caption),
            const SizedBox(height: 4),
            Text(
              offer.notes!,
              style: AppTextStyles.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              backgroundColor: isBestPrice
                  ? AppColors.accent
                  : AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
            ),
            child: Text('✓ قبول', style: AppTextStyles.btnTextSm),
          ),
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ComparisonRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(
            value,
            style: AppTextStyles.bodySm.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Offer Card ────────────────────────────────
class _OfferCard extends StatelessWidget {
  final OfferEntity offer;
  final bool isBestPrice;
  final bool isFastest;
  final VoidCallback onAccept;

  const _OfferCard({
    required this.offer,
    required this.isBestPrice,
    required this.isFastest,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.border;
    if (isBestPrice) borderColor = AppColors.accent;
    if (isFastest) borderColor = AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        borderColor: borderColor,
        borderWidth: (isBestPrice || isFastest) ? 1.5 : 1.0,
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
                      Row(
                        children: [
                          Text(offer.factoryName, style: AppTextStyles.h5),
                          if (isBestPrice) ...[
                            const SizedBox(width: 6),
                            _Badge(
                              label: '🏆 أفضل سعر',
                              gradient: [
                                AppColors.accent,
                                AppColors.accentLight,
                              ],
                            ),
                          ] else if (isFastest) ...[
                            const SizedBox(width: 6),
                            _Badge(
                              label: '⚡ أسرع تسليم',
                              gradient: [
                                AppColors.primary,
                                AppColors.primaryLight,
                              ],
                            ),
                          ],
                        ],
                      ),
                      Text(
                        '★ ${offer.factoryRating.toStringAsFixed(1)}',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFFF59E0B),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${offer.pricePerPiece.toStringAsFixed(0)} ج',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text('/ قطعة', style: AppTextStyles.caption),
                    // P2: Total cost display
                    if (offer.quantity > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'إجمالي: ${offer.totalFormatted}',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '⏱️ التسليم: ${offer.leadTimeDays} يوم',
              style: AppTextStyles.bodySm,
            ),
            if (offer.notes != null && offer.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(offer.notes!, style: AppTextStyles.caption),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusSm,
                          ),
                        ),
                      ),
                      child: Text(
                        'تفاصيل',
                        style: AppTextStyles.btnTextSm.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBestPrice
                            ? AppColors.accent
                            : AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusSm,
                          ),
                        ),
                      ),
                      child: Text('✓ قبول', style: AppTextStyles.btnTextSm),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final List<Color> gradient;
  const _Badge({required this.label, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ════════════════════════════════════
// ORDER SUMMARY PAGE (P0 UX fix)
// ════════════════════════════════════
class OrderSummaryPage extends StatefulWidget {
  final String requestId;
  final String offerId;
  const OrderSummaryPage({
    super.key,
    required this.requestId,
    required this.offerId,
  });

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<OffersCubit>(),
      child: BlocListener<OffersCubit, OffersState>(
        listener: (context, state) {
          if (state is OfferAccepted) {
            context.pushReplacement(
              AppRoutes.waHandoff,
              extra: state.orderData,
            );
          } else if (state is OffersError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: BlocBuilder<OffersCubit, OffersState>(
          builder: (context, state) {
            OfferEntity? offer;
            if (state is OffersLoaded) {
              offer = state.offers
                  .where((o) => o.id == widget.offerId)
                  .firstOrNull;
            }

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                title: const Text('ملخص الطلب'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () => context.pop(),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(height: 1, color: AppColors.border),
                ),
              ),
              body: ResponsiveCenter(
                child: offer == null
                    ? const AppLoading()
                    : _buildContent(context, offer),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, OfferEntity offer) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('راجع التفاصيل قبل التأكيد', style: AppTextStyles.bodySm),
          const SizedBox(height: 14),

          // Factory identity
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryPale,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(color: const Color(0xFFC7D5F8)),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('🏭', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(offer.factoryName, style: AppTextStyles.h5),
                      Text(
                        '★ ${offer.factoryRating.toStringAsFixed(1)}',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFFF59E0B),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accent, AppColors.accentLight],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '🏆 أفضل سعر',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Order details card
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تفاصيل الاتفاق',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                _OrderLine(label: 'نوع المنتج', value: offer.productType),
                _OrderLine(label: 'الكمية', value: '${offer.quantity} قطعة'),
                _OrderLine(
                  label: 'السعر للقطعة',
                  value: '${offer.pricePerPiece.toStringAsFixed(0)} جنيه',
                ),
                _OrderLine(
                  label: 'مدة التسليم',
                  value: '${offer.leadTimeDays} يوم',
                ),
                const SizedBox(height: 8),
                // Total — highlighted
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPale,
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '💰 الإجمالي المتوقع',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        offer.totalFormatted,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Checkbox agreement (P0: deliberate friction)
          GestureDetector(
            onTap: () => setState(() => _agreed = !_agreed),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningBg,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                border: Border.all(
                  color: _agreed
                      ? AppColors.warning
                      : AppColors.warning.withValues(alpha: 0.3),
                  width: _agreed ? 1.5 : 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(top: 2, left: 8),
                    decoration: BoxDecoration(
                      color: _agreed ? AppColors.warning : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppColors.warning, width: 1.5),
                    ),
                    child: _agreed
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 14,
                          )
                        : null,
                  ),
                  Expanded(
                    child: Text(
                      'أوافق على الشروط وتفاصيل الطلب المذكورة أعلاه. أفهم إن الإجمالي المتوقع هو ${offer.totalFormatted}.',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Accept CTA
          BlocBuilder<OffersCubit, OffersState>(
            builder: (context, state) {
              return AppButton(
                label: '🤝 تأكيد القبول وابدأ الطلب',
                onPressed: _agreed
                    ? () => sl<OffersCubit>().acceptOffer(
                        offerId: widget.offerId,
                        requestId: widget.requestId,
                      )
                    : null,
                variant: AppButtonVariant.success,
                isLoading: state is OffersLoading,
              );
            },
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'عودة — اختار عرض مختلف',
            onPressed: () => context.pop(),
            variant: AppButtonVariant.ghost,
            height: AppConstants.buttonHeightSm,
          ),
        ],
      ),
    );
  }
}

class _OrderLine extends StatelessWidget {
  final String label;
  final String value;
  const _OrderLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySm),
          Text(
            value,
            style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
