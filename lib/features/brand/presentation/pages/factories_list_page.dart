import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/widgets/app_asset_widgets.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/utils/performance_utils.dart';
import '../cubit/factories_cubit.dart';
import '../../domain/entities/entities.dart';

// ════════════════════════════════════
// FACTORIES LIST
// ════════════════════════════════════
class FactoriesListPage extends StatefulWidget {
  const FactoriesListPage({super.key});

  @override
  State<FactoriesListPage> createState() => _FactoriesListPageState();
}

class _FactoriesListPageState extends State<FactoriesListPage> {
  String _activeFilter = 'الكل';
  final _filters = ['الكل', 'تيشيرت', 'جينز', 'فستان', 'هوودي', 'سبور'];

  @override
  void initState() {
    super.initState();
    unawaited(sl<FactoriesCubit>().loadFactories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<FactoriesCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('المصانع'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {},
            ),
            IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () {}),
          ],
        ),
        body: ResponsiveCenter(
          maxWidth: 900,
          child: Column(
            children: [
              // Category filter chips
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: _filters.map((f) {
                      final isActive = _activeFilter == f;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: AppChip(
                          label: f,
                          selected: isActive,
                          onTap: () {
                            setState(() => _activeFilter = f);
                            sl<FactoriesCubit>().filterBySpecialty(f);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Divider(height: 1),

              Expanded(
                child: BlocBuilder<FactoriesCubit, FactoriesState>(
                  builder: (context, state) {
                    if (state is FactoriesLoading) {
                      return const AppLoading(message: 'جاري التحميل…');
                    }
                    if (state is FactoriesError) {
                      return NetworkErrorWithIllustration(
                        onRetry: () => sl<FactoriesCubit>().loadFactories(),
                      );
                    }
                    if (state is FactoriesLoaded) {
                      if (state.factories.isEmpty) {
                        return EmptyStateWithIllustration(
                          illustrationAsset: AppAssets.emptyFactories,
                          title: 'ماحدش بالفلاتر دي',
                          subtitle: 'جرب تغيّر نوع المنتج أو المدينة',
                          ctaLabel: 'مسح الفلاتر',
                          onCta: () {
                            setState(() => _activeFilter = 'الكل');
                            unawaited(sl<FactoriesCubit>().loadFactories());
                          },
                        );
                      }

                      final res = AppResponsive.of(context);
                      final isGrid = !res.isPhone;

                      return RefreshIndicator(
                        onRefresh: () async =>
                            sl<FactoriesCubit>().loadFactories(),
                        color: AppColors.primary,
                        child: isGrid
                            ? GridView.builder(
                                padding: const EdgeInsets.all(
                                  AppConstants.spacingMd,
                                ),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: res.gridColumns,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 1.5,
                                    ),
                                itemCount: state.factories.length,
                                itemBuilder: (context, i) => _FactoryListCard(
                                  factory: state.factories[i],
                                  onTap: () => context.push(
                                    '/brand/factories/${state.factories[i].id}',
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(
                                  AppConstants.spacingMd,
                                ),
                                itemCount: state.factories.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, i) {
                                  return _FactoryListCard(
                                    factory: state.factories[i],
                                    onTap: () => context.push(
                                      '/brand/factories/${state.factories[i].id}',
                                    ),
                                  );
                                },
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

class _FactoryListCard extends StatelessWidget {
  final FactoryEntity factory;
  final VoidCallback onTap;
  const _FactoryListCard({required this.factory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('🏭', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(factory.name, style: AppTextStyles.h5),
                    Text(factory.city, style: AppTextStyles.caption),
                    Row(
                      children: [
                        Text(
                          '★ ${factory.ratingFormatted}',
                          style: AppTextStyles.caption.copyWith(
                            color: const Color(0xFFF59E0B),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ' · ${factory.reviewCount} تقييم',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              ...factory.specialties.map(
                (s) => AppChip(label: s, selected: true),
              ),
              AppChip(label: 'من ${factory.minQuantity} قطعة', selected: false),
              if (factory.isFastResponder)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusPill,
                    ),
                  ),
                  child: Text(
                    '✓ رد سريع',
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
    );
  }
}

// ════════════════════════════════════
// FACTORY DETAILS
// ════════════════════════════════════
class FactoryDetailsPage extends StatefulWidget {
  final String factoryId;
  const FactoryDetailsPage({super.key, required this.factoryId});

  @override
  State<FactoryDetailsPage> createState() => _FactoryDetailsPageState();
}

class _FactoryDetailsPageState extends State<FactoryDetailsPage> {
  @override
  void initState() {
    super.initState();
    unawaited(sl<FactoriesCubit>().loadFactoryById(widget.factoryId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<FactoriesCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<FactoriesCubit, FactoriesState>(
          builder: (context, state) {
            if (state is FactoriesLoading) {
              return const Scaffold(body: AppLoading());
            }
            if (state is FactoriesError) {
              return Scaffold(
                appBar: AppBar(),
                body: NetworkErrorWithIllustration(
                  onRetry: () =>
                      sl<FactoriesCubit>().loadFactoryById(widget.factoryId),
                ),
              );
            }
            if (state is FactoryDetailLoaded) {
              return _FactoryDetailContent(factory: state.factory);
            }
            if (state is FactoriesLoaded) {
              final f = state.factories
                  .where((f) => f.id == widget.factoryId)
                  .firstOrNull;
              if (f != null) return _FactoryDetailContent(factory: f);
            }
            return const Scaffold(body: AppLoading());
          },
        ),
      ),
    );
  }
}

class _FactoryDetailContent extends StatelessWidget {
  final FactoryEntity factory;
  const _FactoryDetailContent({required this.factory});

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_rounded, size: 16),
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 12,
                      right: 16,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(color: Color(0x20000000), blurRadius: 8),
                          ],
                        ),
                        child: const Center(
                          child: Text('🏭', style: TextStyle(fontSize: 28)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(factory.name, style: AppTextStyles.h2),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '★ ${factory.ratingFormatted}',
                      style: AppTextStyles.body.copyWith(
                        color: const Color(0xFFF59E0B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' · ${factory.reviewCount} تقييم',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: factory.specialties
                      .map((s) => AppChip(label: s, selected: true))
                      .toList(),
                ),
                const SizedBox(height: 16),

                // Info grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.5,
                  children: [
                    _InfoTile(icon: '📍', label: 'الموقع', value: factory.city),
                    _InfoTile(
                      icon: '📦',
                      label: 'الحد الأدنى',
                      value: '${factory.minQuantity} قطعة',
                    ),
                    _InfoTile(
                      icon: '⏱️',
                      label: 'مدة التسليم',
                      value: '${factory.leadTimeDays} يوم',
                    ),
                    _InfoTile(
                      icon: '⚡',
                      label: 'سرعة الرد',
                      value: factory.isFastResponder ? 'سريع < ساعتين' : 'عادي',
                      valueColor: factory.isFastResponder
                          ? AppColors.success
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Portfolio
                const SectionTitle(title: 'معرض الأعمال'),
                if (factory.portfolioImages.isEmpty)
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPale,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMd,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '📷 لا توجد صور بعد',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                    itemCount: factory.portfolioImages.length,
                    itemBuilder: (_, i) => AppNetworkImage(
                      url: factory.portfolioImages[i],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

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
          Text('$icon $label', style: AppTextStyles.caption),
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
