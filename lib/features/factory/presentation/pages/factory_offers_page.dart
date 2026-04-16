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
import '../../../offers/presentation/cubit/offers_cubit.dart';
import '../../../offers/domain/entities/offer_entity.dart';

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
        backgroundColor: context.colors.background,
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
                itemBuilder: (_, i) =>
                    _FactoryOfferCard(offer: state.offers[i]),
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
        borderColor = context.colors.success;
        statusColor = context.colors.success;
        statusLabel = '✓ مقبول';
        break;
      case OfferStatus.rejected:
        borderColor = context.colors.border;
        statusColor = context.colors.textDisabled;
        statusLabel = '✕ مرفوض';
        break;
      default:
        borderColor = context.colors.warning.withValues(alpha: 0.4);
        statusColor = context.colors.warning;
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
                      style: context.textStyles.h5,
                    ),
                    Text(
                      'عرض: ${offer.pricePerPiece.toStringAsFixed(0)} ج/قطعة · ${offer.leadTimeDays} يوم',
                      style: context.textStyles.caption,
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
                  style: context.textStyles.caption.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(offer.timeAgo, style: context.textStyles.caption),
        ],
      ),
    );
  }
}
