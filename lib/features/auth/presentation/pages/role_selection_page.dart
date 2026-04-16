import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text('أنت مين في Qassa؟', style: context.textStyles.h1),
              const SizedBox(height: 6),
              Text(
                'اختار دورك لتبدأ رحلتك',
                style: context.textStyles.body.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),

              // Brand Card
              _RoleCard(
                emoji: '🎨',
                title: 'أنا صاحب براند',
                subtitle: 'عايز أصنع ملابس وأبني براند',
                gradientColors: [context.colors.accent, context.colors.accentLight],
                valueProps: const [
                  'ابعت طلبك واستقبل عروض من مصانع',
                  'قارن الأسعار واختار الأنسب',
                  'الطلب ينُشر في أقل من 60 ثانية',
                ],
                propDotColor: context.colors.accent,
                ctaLabel: 'ابدأ كصاحب براند ←',
                ctaColor: context.colors.accent,
                onTap: () => context.push('${AppRoutes.emailAuth}?role=brand'),
              ),

              const SizedBox(height: 16),

              // Factory Card
              _RoleCard(
                emoji: '🏭',
                title: 'أنا صاحب مصنع',
                subtitle: 'عندي طاقة إنتاج وعايز عملاء',
                gradientColors: [context.colors.primary, context.colors.primaryLight],
                valueProps: const [
                  'اعرض طلبات البراندات بتخصصك',
                  'ابعت عروض وكسب عملاء جدد',
                  'ابني سمعتك على المنصة',
                ],
                propDotColor: context.colors.primaryLight,
                ctaLabel: 'ابدأ كصاحب مصنع ←',
                ctaColor: context.colors.primary,
                onTap: () =>
                    context.push('${AppRoutes.emailAuth}?role=factory'),
              ),

              const SizedBox(height: 24),
              Center(
                child: Text(
                  'التسجيل مجاني تماماً',
                  style: context.textStyles.caption,
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
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: context.colors.border, width: 1.5),
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
                    Text(title, style: context.textStyles.h4),
                    Text(subtitle, style: context.textStyles.caption),
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
                  Expanded(child: Text(prop, style: context.textStyles.bodySm)),
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
              child: Text(ctaLabel, style: context.textStyles.btnTextSm),
            ),
          ),
        ],
      ),
    );
  }
}
