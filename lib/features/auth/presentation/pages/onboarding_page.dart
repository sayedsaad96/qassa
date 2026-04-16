import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _ctrl = PageController();
  int _currentPage = 0;

  static const List<_OnboardSlide> _slides = [
    _OnboardSlide(
      illustrationAsset: AppAssets.onboard1,
      title: 'ابحث عن مصنعك المثالي',
      subtitle: 'آلاف المصانع المتخصصة في متناول إيدك — ابحث، قارن، واختار.',
    ),
    _OnboardSlide(
      illustrationAsset: AppAssets.onboard2,
      title: 'أرسل طلبك مرة واحدة',
      subtitle: 'أرسل طلبك في أقل من 60 ثانية واستقبل عروض من مصانع متخصصة.',
    ),
    _OnboardSlide(
      illustrationAsset: AppAssets.onboard3,
      title: 'قارن العروض واختار',
      subtitle: 'قارن الأسعار وسرعة التسليم واختار الأنسب لبراندك.',
    ),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: () => context.go(AppRoutes.roleSelection),
                child: Text(
                  'تخطى',
                  style: context.textStyles.body.copyWith(color: context.colors.textSecondary),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (context, i) => _slides[i].build(context),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: i == _currentPage ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == _currentPage ? context.colors.primary : context.colors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
              child: SizedBox(
                width: double.infinity,
                height: AppConstants.buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _slides.length - 1) {
                      _ctrl.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      context.go(AppRoutes.roleSelection);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                  ),
                  child: Text(
                    _currentPage < _slides.length - 1 ? 'التالي ←' : 'ابدأ الآن ←',
                    style: context.textStyles.btnText,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _OnboardSlide {
  final String illustrationAsset;
  final String title;
  final String subtitle;

  const _OnboardSlide({
    required this.illustrationAsset,
    required this.title,
    required this.subtitle,
  });

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusXl),
            child: SvgPicture.asset(
              illustrationAsset,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 32),
          Text(title, style: context.textStyles.h2, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: context.textStyles.body.copyWith(color: context.colors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
