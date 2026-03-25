import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../offers/presentation/cubit/offers_cubit.dart';

// ════════════════════════════════════
// SEND OFFER PAGE
// ════════════════════════════════════
class SendOfferPage extends StatefulWidget {
  final String requestId;
  const SendOfferPage({super.key, required this.requestId});

  @override
  State<SendOfferPage> createState() => _SendOfferPageState();
}

class _SendOfferPageState extends State<SendOfferPage> {
  final _formKey = GlobalKey<FormState>();
  final _priceCtrl = TextEditingController();
  final _leadCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _priceCtrl.dispose();
    _leadCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<OffersCubit>(),
      child: BlocListener<OffersCubit, OffersState>(
        listener: (context, state) {
          if (state is OfferSent) {
            context.pop();
            context.pop();
            AppSnackBar.showSuccess(
              context,
              '✅ اتبعت عرضك! هنبلغك لما صاحب البراند يرد',
            );
          } else if (state is OffersError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            title: const Text('إرسال عرض'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => context.pop(),
            ),
          ),
          body: ResponsiveCenter(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Market context hint for factory
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.successBg,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusSm,
                        ),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'طلبات مشابهة على المنصة: 35–55 ج/قطعة — كن تنافسياً!',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text('سعرك للقطعة', style: AppTextStyles.label),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            hint: 'مثال: 38',
                            controller: _priceCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'ادخل السعر';
                              }
                              if (double.tryParse(v) == null) {
                                return 'سعر غير صحيح';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'جنيه / قطعة',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Text('مدة التنفيذ', style: AppTextStyles.label),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            hint: 'مثال: 18',
                            controller: _leadCtrl,
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'ادخل مدة التنفيذ';
                              }
                              if (int.tryParse(v) == null) {
                                return 'قيمة غير صحيحة';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'يوم',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Text('ملاحظة', style: AppTextStyles.label),
                    Text('اختياري', style: AppTextStyles.caption),
                    const SizedBox(height: 6),
                    AppTextField(
                      hint: 'أي معلومات إضافية عن المصنع أو الخامات…',
                      controller: _notesCtrl,
                      maxLines: 3,
                      maxLength: 120,
                    ),
                    const SizedBox(height: 32),

                    BlocBuilder<OffersCubit, OffersState>(
                      builder: (context, state) {
                        return AppButton(
                          label: '📤 إرسال العرض',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              sl<OffersCubit>().sendOffer(
                                requestId: widget.requestId,
                                pricePerPiece: double.parse(_priceCtrl.text),
                                leadTimeDays: int.parse(_leadCtrl.text),
                                notes: _notesCtrl.text.trim().isEmpty
                                    ? null
                                    : _notesCtrl.text.trim(),
                              );
                            }
                          },
                          isLoading: state is OffersLoading,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
