import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/widgets/app_asset_widgets.dart';
class NotifPrimePage extends StatelessWidget {
  const NotifPrimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
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
                  gradient: LinearGradient(colors: [context.colors.primary, context.colors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.primary.withValues(alpha: 0.3),
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
              Text('ابقى أول المُبلَّغين!', style: context.textStyles.h2),
              const SizedBox(height: 12),
              Text(
                'هنبعتلك إشعار فور ما أي مصنع يبعت عرض على طلبك — عشان تقدر ترد بسرعة وتختار الأحسن.',
                style: context.textStyles.body.copyWith(color: context.colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Benefit pills
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _BenefitPill(label: '⚡ ردود سريعة', bg: context.colors.successBg, color: context.colors.success),
                  const SizedBox(width: 8),
                  _BenefitPill(label: '🏆 عروض أفضل', bg: context.colors.primaryPale, color: context.colors.primary),
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
                style: context.textStyles.caption,
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
        style: context.textStyles.caption.copyWith(color: color, fontWeight: FontWeight.w700),
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
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Column(
            children: [
              const SizedBox(height: 16),
              SvgIllustration(AppAssets.successAccepted, width: 160, height: 160),
              const SizedBox(height: 16),
              Text('تم قبول العرض!', style: context.textStyles.h2),
              const SizedBox(height: 8),
              Text(
                'تواصل مع $factoryName على واتساب لتأكيد التفاصيل وبدء الإنتاج',
                style: context.textStyles.body.copyWith(color: context.colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Order ref
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.colors.background,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(color: context.colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('رقم الطلب للمرجعية', style: context.textStyles.caption),
                    Text(
                      '#$requestNum',
                      style: context.textStyles.h3.copyWith(
                        color: context.colors.primary,
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
                      style: context.textStyles.h5.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'هتبعت الرسالة دي تلقائياً:',
                      style: context.textStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8)),
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
                        style: context.textStyles.bodySm.copyWith(color: Colors.white),
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
                          style: context.textStyles.btnTextSm.copyWith(color: const Color(0xFF25D366)),
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
