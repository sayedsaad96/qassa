import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../cubit/factories_cubit.dart';
import '../../domain/entities/entities.dart';

class BrandHomePage extends StatefulWidget {
  const BrandHomePage({super.key});

  @override
  State<BrandHomePage> createState() => _BrandHomePageState();
}

class _BrandHomePageState extends State<BrandHomePage> {
  String _firstName = '';
  String _brandNameVal = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
    unawaited(sl<FactoriesCubit>().loadFactories());
  }

  Future<void> _loadUser() async {
    final svc = sl<UserService>();
    final first = await svc.displayName;
    final brand = await svc.brandName;
    if (mounted) {
      setState(() {
        _firstName = first;
        _brandNameVal = brand;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<FactoriesCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: RefreshIndicator(
          onRefresh: () async {
            await sl<UserService>().getProfile(forceRefresh: true);
            unawaited(sl<FactoriesCubit>().loadFactories());
            _loadUser();
          },
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0D2260), AppColors.primary, AppColors.primaryLight],
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
                            'Qassa ✨',
                            style: AppTextStyles.h4.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _firstName.isEmpty ? 'أهلاً 👋' : 'أهلاً، $_firstName 👋',
                            style: AppTextStyles.h2.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w900,
                            ),
                          ),
                          if (_brandNameVal.isNotEmpty)
                            Text(
                              'براند: $_brandNameVal',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white.withValues(alpha:0.75),
                              ),
                            ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha:0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text('🔔', style: TextStyle(fontSize: 20)),
                          ),
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
                    // CTA banner
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('🚀 ابدأ أول طلب تصنيع', style: AppTextStyles.h4),
                          const SizedBox(height: 4),
                          Text(
                            'أرسل طلبك في أقل من 60 ثانية واستقبل عروض من مصانع متخصصة',
                            style: AppTextStyles.bodySm,
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            label: '+ إنشاء طلب',
                            onPressed: () => context.push(AppRoutes.createRequest),
                            height: AppConstants.buttonHeightSm,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SectionTitle(title: 'مصانع موصى بيها 🔥'),
                    BlocBuilder<FactoriesCubit, FactoriesState>(
                      builder: (context, state) {
                        if (state is FactoriesLoading) {
                          return const SizedBox(height: 100, child: AppLoading());
                        }
                        if (state is FactoriesLoaded) {
                          return Column(
                            children: state.factories
                                .take(3)
                                .map((f) => _FactoryCard(
                                      factory: f,
                                      onTap: () => context.push(
                                        '${AppRoutes.factoriesList}/${f.id}',
                                      ),
                                    ))
                                .toList(),
                          );
                        }
                        return const SizedBox();
                      },
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

class _FactoryCard extends StatelessWidget {
  final FactoryEntity factory;
  final VoidCallback onTap;
  const _FactoryCard({required this.factory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('🏭', style: TextStyle(fontSize: 22))),
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
                        ),
                      ),
                      Text(' · ${factory.reviewCount} تقييم',
                          style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryPale,
                borderRadius: BorderRadius.circular(AppConstants.radiusPill),
              ),
              child: Text(
                'من ${factory.minQuantity} ق',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
