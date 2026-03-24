import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/widgets/app_asset_widgets.dart';
class NotifPrimePage extends StatelessWidget {
  const NotifPrimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with glow
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🔔', style: TextStyle(fontSize: 42)),
                ),
              ),
              const SizedBox(height: 24),
              Text('ابقى أول المُبلَّغين!', style: AppTextStyles.h2),
              const SizedBox(height: 12),
              Text(
                'هنبعتلك إشعار فور ما أي مصنع يبعت عرض على طلبك — عشان تقدر ترد بسرعة وتختار الأحسن.',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Benefit pills
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _BenefitPill(label: '⚡ ردود سريعة', bg: AppColors.successBg, color: AppColors.success),
                  const SizedBox(width: 8),
                  _BenefitPill(label: '🏆 عروض أفضل', bg: AppColors.primaryPale, color: AppColors.primary),
                ],
              ),
              const SizedBox(height: 36),

              AppButton(
                label: 'وافق على الإشعارات ←',
                onPressed: () {
                  // In production: call permission_handler
                  context.go(AppRoutes.myRequests);
                },
              ),
              const SizedBox(height: 10),
              AppButton(
                label: 'مش دلوقتي',
                onPressed: () => context.go(AppRoutes.myRequests),
                variant: AppButtonVariant.ghost,
                height: AppConstants.buttonHeightSm,
              ),
              const SizedBox(height: 12),
              Text(
                'لن نرسل إشعارات غير ضرورية',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitPill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color color;
  const _BenefitPill({required this.label, required this.bg, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppConstants.radiusPill),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// WA HANDOFF PAGE (P1 UX fix)
// ═══════════════════════════════════════════════
class WaHandoffPage extends StatelessWidget {
  final Map<String, dynamic> orderData;
  const WaHandoffPage({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final factoryName = orderData['factory_name'] ?? 'المصنع';
    final productType = orderData['product_type'] ?? '';
    final quantity = orderData['quantity'] ?? 0;
    final price = orderData['price_per_piece'] ?? 0;
    final total = orderData['total'] ?? 0;
    final leadTime = orderData['lead_time_days'] ?? 0;
    final requestNum = orderData['request_number'] ?? 'QS-0000';

    final waMessage =
        'أهلاً، أنا من تطبيق Qassa. اتفقنا على طلب رقم #$requestNum — $productType $quantity قطعة بسعر $price ج/قطعة. إجمالي: $total ج. تسليم: $leadTime يوم. نبدأ؟ 🙏';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Column(
            children: [
              const SizedBox(height: 16),
              SvgIllustration(AppAssets.successAccepted, width: 160, height: 160),
              const SizedBox(height: 16),
              Text('تم قبول العرض!', style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Text(
                'تواصل مع $factoryName على واتساب لتأكيد التفاصيل وبدء الإنتاج',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Order ref
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('رقم الطلب للمرجعية', style: AppTextStyles.caption),
                    Text(
                      '#$requestNum',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.primary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // WA card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📱 رسالة جاهزة على واتساب',
                      style: AppTextStyles.h5.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'هتبعت الرسالة دي تلقائياً:',
                      style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                        border: Border(
                          right: BorderSide(color: Colors.white.withValues(alpha: 0.5), width: 3),
                        ),
                      ),
                      child: Text(
                        waMessage,
                        style: AppTextStyles.bodySm.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          // In production: url_launcher to wa.me
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF25D366),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                          ),
                        ),
                        child: Text(
                          'افتح واتساب',
                          style: AppTextStyles.btnTextSm.copyWith(color: const Color(0xFF25D366)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              AppButton(
                label: 'عودة لطلباتي',
                onPressed: () => context.go(AppRoutes.myRequests),
                variant: AppButtonVariant.outline,
                height: AppConstants.buttonHeightSm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
