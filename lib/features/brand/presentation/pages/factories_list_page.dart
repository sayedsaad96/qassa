import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_constants.dart';
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
  final _searchController = TextEditingController();
  bool _isSearching = false;
  String _activeFilter = 'الكل';
  final _specialties = [
    'الكل',
    'تيشيرت',
    'جينز',
    'فستان',
    'هوودي',
    'سبور',
    'جاكيت',
    'بيجامة',
    'شورت',
    'بولو',
  ];

  @override
  void initState() {
    super.initState();
    unawaited(sl<FactoriesCubit>().loadFactories());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() => _isSearching = !_isSearching);
    if (!_isSearching) {
      _searchController.clear();
      sl<FactoriesCubit>().search('');
    }
  }

  void _showFilterDialog(BuildContext context, FactoryFilter currentFilter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: sl<FactoriesCubit>(),
        child: _FilterBottomSheet(
          currentFilter: currentFilter,
          specialties: _specialties.where((s) => s != 'الكل').toList(),
          onApply: (filter) {
            setState(() => _activeFilter = filter.specialty ?? 'الكل');
            sl<FactoriesCubit>().applyFilter(filter);
          },
          onClear: () {
            setState(() => _activeFilter = 'الكل');
            sl<FactoriesCubit>().clearFilter();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<FactoriesCubit>(),
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: context.textStyles.body,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن مصنع، مدينة، أو تخصص…',
                    hintStyle: context.textStyles.caption,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (q) => sl<FactoriesCubit>().search(q),
                )
              : const Text('المصانع'),
          actions: [
            // Search icon
            IconButton(
              icon: Icon(
                _isSearching ? Icons.close_rounded : Icons.search_rounded,
              ),
              onPressed: _toggleSearch,
            ),
            // Filter icon with badge
            BlocBuilder<FactoriesCubit, FactoriesState>(
              builder: (context, state) {
                final filterCount = state is FactoriesLoaded
                    ? state.filter.activeCount
                    : 0;
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.tune_rounded),
                      onPressed: () {
                        _showFilterDialog(
                          context,
                          state is FactoriesLoaded
                              ? state.filter
                              : const FactoryFilter(),
                        );
                      },
                    ),
                    if (filterCount > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: context.colors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$filterCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: ResponsiveCenter(
          maxWidth: 900,
          child: Column(
            children: [
              // Category filter chips row
              Container(
                color: context.colors.surface,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: _specialties.map((f) {
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
                        // No results for search/filter
                        return EmptyStateWithIllustration(
                          illustrationAsset: AppAssets.emptyFactories,
                          title: state.searchQuery.isNotEmpty
                              ? 'مفيش نتايج لـ "${state.searchQuery}"'
                              : 'ماحدش بالفلاتر دي',
                          subtitle: state.searchQuery.isNotEmpty
                              ? 'جرب كلمة تانية'
                              : 'جرب تغيّر نوع المنتج أو المدينة',
                          ctaLabel: 'مسح الفلاتر',
                          onCta: () {
                            setState(() => _activeFilter = 'الكل');
                            _searchController.clear();
                            sl<FactoriesCubit>().clearFilter();
                          },
                        );
                      }

                      // Show results count + active filters bar
                      return Column(
                        children: [
                          // Results info bar
                          if (state.searchQuery.isNotEmpty ||
                              !state.filter.isEmpty)
                            Container(
                              color: context.colors.primaryPale,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 14,
                                    color: context.colors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'عُثر على ${state.factories.length} مصنع',
                                      style: context.textStyles.caption.copyWith(
                                        color: context.colors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  // Clear all
                                  GestureDetector(
                                    onTap: () {
                                      setState(() => _activeFilter = 'الكل');
                                      _searchController.clear();
                                      sl<FactoriesCubit>().clearFilter();
                                    },
                                    child: Text(
                                      'مسح الكل',
                                      style: context.textStyles.caption.copyWith(
                                        color: context.colors.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async =>
                                  sl<FactoriesCubit>().loadFactories(),
                              color: context.colors.primary,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(
                                  AppConstants.spacingMd,
                                ),
                                itemCount: state.factories.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, i) {
                                  final factory = state.factories[i];
                                  return _FactoryListCard(
                                    factory: factory,
                                    searchQuery: state.searchQuery,
                                    onTap: () => context.push(
                                      '/brand/factories/${factory.id}',
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
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
// FACTORY CARD
// ════════════════════════════════════
class _FactoryListCard extends StatelessWidget {
  final FactoryEntity factory;
  final VoidCallback onTap;
  final String searchQuery;

  const _FactoryListCard({
    required this.factory,
    required this.onTap,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Factory logo/icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [context.colors.primary, context.colors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🏭', style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),

              // Factory info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + fast responder badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: _HighlightedText(
                            text: factory.name,
                            query: searchQuery,
                            style: context.textStyles.h5,
                          ),
                        ),
                        if (factory.isFastResponder) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.successBg,
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusPill,
                              ),
                            ),
                            child: Text(
                              '⚡ رد سريع',
                              style: context.textStyles.caption.copyWith(
                                color: context.colors.success,
                                fontWeight: FontWeight.w700,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),

                    // City
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: context.colors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        _HighlightedText(
                          text: factory.city,
                          query: searchQuery,
                          style: context.textStyles.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Rating + reviews
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          factory.ratingFormatted,
                          style: context.textStyles.caption.copyWith(
                            color: const Color(0xFFF59E0B),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ' · ${factory.reviewCount} تقييم',
                          style: context.textStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_back_ios_rounded,
                size: 14,
                color: context.colors.textSecondary,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Divider
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 10),

          // Bottom row: specialties + lead time + min quantity
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Specialties chips
              Expanded(
                child: Wrap(
                  spacing: 5,
                  runSpacing: 4,
                  children: factory.specialties.take(3).map((s) {
                    final isHighlighted =
                        searchQuery.isNotEmpty &&
                        s.toLowerCase().contains(searchQuery.toLowerCase());
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? context.colors.primary
                            : context.colors.primaryPale,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusPill),
                      ),
                      child: Text(
                        s,
                        style: context.textStyles.caption.copyWith(
                          color: isHighlighted
                              ? Colors.white
                              : context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Stats column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatBadge(
                    icon: '📦',
                    label: 'من ${factory.minQuantity} قطعة',
                  ),
                  const SizedBox(height: 4),
                  _StatBadge(
                    icon: '⏱️',
                    label: '${factory.leadTimeDays} يوم',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String icon;
  final String label;
  const _StatBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusPill),
        border: Border.all(color: context.colors.border),
      ),
      child: Text(
        '$icon $label',
        style: context.textStyles.caption.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}

/// Highlights search query in text
class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? style;

  const _HighlightedText({
    required this.text,
    required this.query,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) return Text(text, style: style);

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final idx = lowerText.indexOf(lowerQuery);
    if (idx == -1) return Text(text, style: style);

    return RichText(
      text: TextSpan(
        style: style ?? DefaultTextStyle.of(context).style,
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: text.substring(idx, idx + query.length),
            style: (style ?? const TextStyle()).copyWith(
              backgroundColor: context.colors.primary.withValues(alpha: 0.15),
              color: context.colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: text.substring(idx + query.length)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════
// FILTER BOTTOM SHEET
// ════════════════════════════════════
class _FilterBottomSheet extends StatefulWidget {
  final FactoryFilter currentFilter;
  final List<String> specialties;
  final void Function(FactoryFilter) onApply;
  final VoidCallback onClear;

  const _FilterBottomSheet({
    required this.currentFilter,
    required this.specialties,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late String? _specialty;
  late String? _city;
  late bool _fastResponder;
  late int? _maxLeadTime;
  late int? _maxMinQuantity;

  final _cities = [
    'القاهرة',
    'الإسكندرية',
    'الجيزة',
    'المنصورة',
    '10 رمضان',
    'بورسعيد',
    'السادات',
  ];

  final _leadTimes = [7, 14, 21, 30];
  final _quantities = [50, 100, 200, 500];

  @override
  void initState() {
    super.initState();
    _specialty = widget.currentFilter.specialty;
    _city = widget.currentFilter.city;
    _fastResponder = widget.currentFilter.fastResponderOnly ?? false;
    _maxLeadTime = widget.currentFilter.maxLeadTimeDays;
    _maxMinQuantity = widget.currentFilter.maxMinQuantity;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('فلتر المصانع', style: context.textStyles.h4),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onClear();
                },
                child: Text(
                  'مسح الكل',
                  style: context.textStyles.bodySm.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Specialty Section
          _SectionLabel(label: '🏭 التخصص'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.specialties.map((s) {
              final isSelected = _specialty == s;
              return GestureDetector(
                onTap: () => setState(
                  () => _specialty = isSelected ? null : s,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? context.colors.primary : context.colors.background,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusPill),
                    border: Border.all(
                      color: isSelected
                          ? context.colors.primary
                          : context.colors.border,
                    ),
                  ),
                  child: Text(
                    s,
                    style: context.textStyles.bodySm.copyWith(
                      color: isSelected
                          ? Colors.white
                          : context.colors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // City Section
          _SectionLabel(label: '📍 المدينة'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _cities.map((c) {
              final isSelected = _city == c;
              return GestureDetector(
                onTap: () =>
                    setState(() => _city = isSelected ? null : c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colors.primary
                        : context.colors.background,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusPill),
                    border: Border.all(
                      color: isSelected
                          ? context.colors.primary
                          : context.colors.border,
                    ),
                  ),
                  child: Text(
                    c,
                    style: context.textStyles.bodySm.copyWith(
                      color: isSelected
                          ? Colors.white
                          : context.colors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Max lead time
          _SectionLabel(label: '⏱️ أقصى مدة تسليم (بالأيام)'),
          const SizedBox(height: 8),
          Row(
            children: _leadTimes.map((d) {
              final isSelected = _maxLeadTime == d;
              return Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _maxLeadTime = isSelected ? null : d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colors.primary
                          : context.colors.background,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSm),
                      border: Border.all(
                        color: isSelected
                            ? context.colors.primary
                            : context.colors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$d',
                        style: context.textStyles.label.copyWith(
                          color: isSelected
                              ? Colors.white
                              : context.colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Max min quantity
          _SectionLabel(label: '📦 الحد الأدنى للكمية'),
          const SizedBox(height: 8),
          Row(
            children: _quantities.map((q) {
              final isSelected = _maxMinQuantity == q;
              return Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _maxMinQuantity = isSelected ? null : q),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colors.primary
                          : context.colors.background,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSm),
                      border: Border.all(
                        color: isSelected
                            ? context.colors.primary
                            : context.colors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$q',
                        style: context.textStyles.label.copyWith(
                          color: isSelected
                              ? Colors.white
                              : context.colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Fast responder toggle
          GestureDetector(
            onTap: () => setState(() => _fastResponder = !_fastResponder),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _fastResponder
                    ? context.colors.successBg
                    : context.colors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(
                  color: _fastResponder
                      ? context.colors.success
                      : context.colors.border,
                  width: _fastResponder ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: _fastResponder
                          ? context.colors.success
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: context.colors.success,
                        width: 1.5,
                      ),
                    ),
                    child: _fastResponder
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 15,
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '⚡ رد سريع فقط',
                          style: context.textStyles.label.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _fastResponder
                                ? context.colors.success
                                : context.colors.textPrimary,
                          ),
                        ),
                        Text(
                          'عرض المصانع التي تردّ خلال ساعتين',
                          style: context.textStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Apply Button
          SizedBox(
            width: double.infinity,
            height: AppConstants.buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onApply(
                  FactoryFilter(
                    specialty: _specialty,
                    city: _city,
                    fastResponderOnly: _fastResponder ? true : null,
                    maxLeadTimeDays: _maxLeadTime,
                    maxMinQuantity: _maxMinQuantity,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMd),
                ),
              ),
              child: Text('تطبيق الفلتر', style: context.textStyles.btnText),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textStyles.label.copyWith(
        color: context.colors.textSecondary,
        fontWeight: FontWeight.w700,
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
        backgroundColor: context.colors.background,
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [context.colors.primary, context.colors.primaryLight],
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
                            BoxShadow(
                                color: Color(0x20000000), blurRadius: 8),
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
                Text(factory.name, style: context.textStyles.h2),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '★ ${factory.ratingFormatted}',
                      style: context.textStyles.body.copyWith(
                        color: const Color(0xFFF59E0B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' · ${factory.reviewCount} تقييم',
                      style: context.textStyles.body.copyWith(
                        color: context.colors.textSecondary,
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
                    _InfoTile(
                        icon: '📍', label: 'الموقع', value: factory.city),
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
                      value: factory.isFastResponder
                          ? 'سريع < ساعتين'
                          : 'عادي',
                      valueColor: factory.isFastResponder
                          ? context.colors.success
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
                      color: context.colors.primaryPale,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMd,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '📷 لا توجد صور بعد',
                        style: TextStyle(color: context.colors.textSecondary),
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
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$icon $label', style: context.textStyles.caption),
          Text(
            value,
            style: context.textStyles.label.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor ?? context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}