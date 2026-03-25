import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/widgets/app_asset_widgets.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../brand/domain/entities/entities.dart';
import '../../../brand/domain/usecases/get_request_by_id_usecase.dart';

// ════════════════════════════════════
// REQUEST DETAIL PAGE (P0: brand identity)
// ════════════════════════════════════
class RequestDetailPage extends StatefulWidget {
  final String requestId;
  const RequestDetailPage({super.key, required this.requestId});

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  RequestEntity? _request;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRequest();
  }

  Future<void> _loadRequest() async {
    try {
      final result = await sl<GetRequestByIdUseCase>().call(widget.requestId);
      result.fold(
        (error) {
          if (!mounted) return;
          setState(() {
            _error = error;
            _loading = false;
          });
        },
        (req) {
          if (!mounted) return;
          setState(() {
            _request = req;
            _loading = false;
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'حدث خطأ في تحميل الطلب';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: AppLoading());
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: NetworkErrorWithIllustration(onRetry: _loadRequest),
      );
    }
    final req = _request!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '#${req.requestNumber ?? req.id.substring(0, 8).toUpperCase()}',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.textSecondary,
            fontFamily: 'monospace',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsiveCenter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // P0 FIX: Brand Identity Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryPale, Colors.white],
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(color: const Color(0xFFC7D5F8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '👤 صاحب الطلب',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.accent, AppColors.accentLight],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              req.brandAvatarInitial ??
                                  req.brandName[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(req.brandName, style: AppTextStyles.h5),
                              Text(
                                'عضو على المنصة',
                                style: AppTextStyles.caption,
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
                            color: AppColors.successBg,
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusPill,
                            ),
                          ),
                          child: Text(
                            '✓ براند موثق',
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
              ),
              const SizedBox(height: 14),

              // Request details grid
              AppCard(
                child: Column(
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.5,
                      children: [
                        _DetailTile(
                          label: 'النوع',
                          value:
                              '${_emoji(req.productType)} ${req.productType}',
                        ),
                        _DetailTile(
                          label: 'الكمية',
                          value: '${req.quantity} قطعة',
                        ),
                        _DetailTile(
                          label: 'المواد',
                          value: req.material,
                          valueColor: req.material != 'مش محدد'
                              ? AppColors.primary
                              : null,
                        ),
                        _DetailTile(
                          label: 'الجودة',
                          value: req.qualityLabel,
                          valueColor: req.quality == RequestQuality.high
                              ? Colors.orange
                              : req.quality == RequestQuality.low
                              ? AppColors.textSecondary
                              : AppColors.primary,
                        ),
                        _DetailTile(
                          label: 'الميزانية',
                          value: req.targetPricePerPiece != null
                              ? '~${req.targetPricePerPiece!.toStringAsFixed(0)} ج/ق'
                              : 'غير محدد',
                          valueColor: req.targetPricePerPiece != null
                              ? AppColors.success
                              : null,
                        ),
                      ],
                    ),
                    if (req.notes != null && req.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusSm,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ملاحظات', style: AppTextStyles.caption),
                            const SizedBox(height: 4),
                            Text(req.notes!, style: AppTextStyles.body),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              if (req.referenceImageUrl != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPale,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    border: Border.all(color: const Color(0xFFC7D5F8)),
                  ),
                  child: const Center(
                    child: Text(
                      '📎 صورة مرجعية متاحة للعرض',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ResponsiveCenter(
        child: Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: AppButton(
            label: '📤 إرسال عرض ←',
            onPressed: () => context.push(
              '${AppRoutes.factoryRequests}/${widget.requestId}/send-offer',
            ),
          ),
        ),
      ),
    );
  }

  String _emoji(String t) {
    switch (t) {
      case 'تيشيرت':
        return '👕';
      case 'جينز':
        return '👖';
      case 'فستان':
        return '👗';
      case 'هوودي':
        return '🧥';
      default:
        return '📦';
    }
  }
}

class _DetailTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _DetailTile({
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
          Text(label, style: AppTextStyles.caption),
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
