import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text('أنت مين في Qassa؟', style: AppTextStyles.h1),
              const SizedBox(height: 6),
              Text(
                'اختار دورك لتبدأ رحلتك',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),

              // Brand Card
              _RoleCard(
                emoji: '🎨',
                title: 'أنا صاحب براند',
                subtitle: 'عايز أصنع ملابس وأبني براند',
                gradientColors: [AppColors.accent, AppColors.accentLight],
                valueProps: const [
                  'ابعت طلبك واستقبل عروض من مصانع',
                  'قارن الأسعار واختار الأنسب',
                  'الطلب ينُشر في أقل من 60 ثانية',
                ],
                propDotColor: AppColors.accent,
                ctaLabel: 'ابدأ كصاحب براند ←',
                ctaColor: AppColors.accent,
                onTap: () => context.push('${AppRoutes.emailAuth}?role=brand'),
              ),

              const SizedBox(height: 16),

              // Factory Card
              _RoleCard(
                emoji: '🏭',
                title: 'أنا صاحب مصنع',
                subtitle: 'عندي طاقة إنتاج وعايز عملاء',
                gradientColors: [AppColors.primary, AppColors.primaryLight],
                valueProps: const [
                  'اعرض طلبات البراندات بتخصصك',
                  'ابعت عروض وكسب عملاء جدد',
                  'ابني سمعتك على المنصة',
                ],
                propDotColor: AppColors.primaryLight,
                ctaLabel: 'ابدأ كصاحب مصنع ←',
                ctaColor: AppColors.primary,
                onTap: () =>
                    context.push('${AppRoutes.emailAuth}?role=factory'),
              ),

              const SizedBox(height: 24),
              Center(
                child: Text(
                  'التسجيل مجاني تماماً',
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final List<String> valueProps;
  final Color propDotColor;
  final String ctaLabel;
  final Color ctaColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.valueProps,
    required this.propDotColor,
    required this.ctaLabel,
    required this.ctaColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.h4),
                    Text(subtitle, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...valueProps.map(
            (prop) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(left: 8, top: 1),
                    decoration: BoxDecoration(
                      color: propDotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(child: Text(prop, style: AppTextStyles.bodySm)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: AppConstants.buttonHeightSm,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: ctaColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                elevation: 0,
              ),
              child: Text(ctaLabel, style: AppTextStyles.btnTextSm),
            ),
          ),
        ],
      ),
    );
  }
}
