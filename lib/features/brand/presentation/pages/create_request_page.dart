import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../domain/entities/entities.dart';
import '../cubit/requests_cubit.dart';

class CreateRequestPage extends StatefulWidget {
  final String? preselectedFactoryId;
  const CreateRequestPage({super.key, this.preselectedFactoryId});

  @override
  State<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  int _step = 1;

  // Step 1
  String? _selectedType;
  int _quantity = 500;
  String _selectedMaterial = 'مش محدد';
  RequestQuality _selectedQuality = RequestQuality.medium;

  // Step 2
  final _priceCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _priceCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  bool get _step1Valid => _selectedType != null;

  String get _marketHint {
    if (_selectedType == null) return '';
    final range = AppConstants.marketPriceRanges[_selectedType];
    if (range == null) return '';
    return 'نطاق السوق لـ $_selectedType ($_quantity قطعة): المصانع بتقبل من ${range['rangeStr']} للقطعة.';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<RequestsCubit>(),
      child: BlocListener<RequestsCubit, RequestsState>(
        listener: (context, state) {
          if (state is RequestCreated) {
            context.pushReplacement(AppRoutes.notifPrime);
          } else if (state is RequestsError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            title: const Text('إنشاء طلب'),
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => context.pop(),
            ),
          ),
          body: ResponsiveCenter(
            child: Column(
              children: [
                // ── Step indicator ──────────────────
                _StepBar(currentStep: _step, totalSteps: 2),

                // ── Body ────────────────────────────
                Expanded(child: _step == 1 ? _buildStep1() : _buildStep2()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // STEP 1: Type + Quantity + Material
  // ─────────────────────────────────────
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('إيه نوع المنتج والكمية؟', style: AppTextStyles.h3),
          const SizedBox(height: 20),

          // Product type
          Text('النوع', style: AppTextStyles.label),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.1,
            ),
            itemCount: AppConstants.productTypes.length,
            itemBuilder: (context, i) {
              final type = AppConstants.productTypes[i];
              final label = type['label']!;
              final isSelected = _selectedType == label;
              return GestureDetector(
                onTap: () => setState(() => _selectedType = label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryPale
                        : AppColors.background,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1.5,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        type['emoji']!,
                        style: const TextStyle(fontSize: 26),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Quantity
          Text('الكمية', style: AppTextStyles.label),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 80,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  border: Border.all(color: AppColors.primaryLight, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '$_quantity',
                    style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Slider(
                  value: _quantity.toDouble().clamp(100, 5000),
                  min: 100,
                  max: 5000,
                  divisions: 49,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.border,
                  onChanged: (v) => setState(() => _quantity = v.round()),
                ),
              ),
              Text('قطعة', style: AppTextStyles.caption),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('100', style: AppTextStyles.caption),
              Text('2500', style: AppTextStyles.caption),
              Text('5000+', style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 20),

          // Quality Segment
          Text('مستوى الجودة المطلوب', style: AppTextStyles.label),
          const SizedBox(height: 8),
          SegmentedButton<RequestQuality>(
            segments: const [
              ButtonSegment(value: RequestQuality.low, label: Text('منخفضة')),
              ButtonSegment(
                value: RequestQuality.medium,
                label: Text('متوسطة'),
              ),
              ButtonSegment(value: RequestQuality.high, label: Text('عالية')),
            ],
            selected: {_selectedQuality},
            onSelectionChanged: (Set<RequestQuality> newSelection) {
              setState(() {
                _selectedQuality = newSelection.first;
              });
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryPale; // selected
                }
                return AppColors.background; // normal
              }),
              side: WidgetStateProperty.resolveWith<BorderSide>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return const BorderSide(color: AppColors.primary, width: 1.5);
                }
                return const BorderSide(color: AppColors.border, width: 1);
              }),
            ),
          ),
          const SizedBox(height: 20),

          // Material (P2 fix)
          Text('الخامة', style: AppTextStyles.label),
          const SizedBox(height: 4),
          Text('اختياري — يساعد في دقة العروض', style: AppTextStyles.caption),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.materialTypes.map((mat) {
              final isSelected = _selectedMaterial == mat;
              return AppChip(
                label: mat,
                selected: isSelected,
                onTap: () => setState(() => _selectedMaterial = mat),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          AppButton(
            label: 'التالي ←',
            onPressed: _step1Valid ? () => setState(() => _step = 2) : null,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // STEP 2: Optional details + market hint
  // ─────────────────────────────────────
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تفاصيل إضافية', style: AppTextStyles.h3),
          const SizedBox(height: 6),
          Text(
            'هذه الخطوة اختيارية — تفاصيل أكتر تجيب عروض أفضل',
            style: AppTextStyles.bodySm,
          ),
          const SizedBox(height: 16),

          // P1: Market price hint
          if (_selectedType != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryPale, Color(0xFFDBEAFE)],
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                border: Border.all(color: AppColors.primaryPale),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _marketHint,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Target price
          Text('السعر المستهدف للقطعة', style: AppTextStyles.label),
          Text('اختياري', style: AppTextStyles.caption),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  hint: 'مثال: 45',
                  controller: _priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
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

          // Image upload placeholder
          Text('صورة مرجعية', style: AppTextStyles.label),
          Text('اختياري', style: AppTextStyles.caption),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              // Image pick — wired in production
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.border2, width: 1.5),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Column(
                children: [
                  const Text('📎', style: TextStyle(fontSize: 26)),
                  const SizedBox(height: 6),
                  Text('اضغط لرفع صورة', style: AppTextStyles.bodySm),
                  Text('JPG / PNG · حد أقصى 5MB', style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Notes
          Text('ملاحظة للمصنع', style: AppTextStyles.label),
          Text('اختياري', style: AppTextStyles.caption),
          const SizedBox(height: 6),
          AppTextField(
            hint: 'أي تفاصيل مهمة للمصنع…',
            controller: _notesCtrl,
            maxLines: 3,
            maxLength: 120,
          ),
          const SizedBox(height: 32),

          // Primary CTA
          BlocBuilder<RequestsCubit, RequestsState>(
            builder: (context, state) {
              return AppButton(
                label: '🚀 نشر الطلب فوراً',
                onPressed: () => _publish(context),
                isLoading: state is RequestsLoading,
              );
            },
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'تخطى وانشر بدون تفاصيل',
            onPressed: () => _publish(context),
            variant: AppButtonVariant.ghost,
            height: AppConstants.buttonHeightSm,
          ),
        ],
      ),
    );
  }

  Future<void> _publish(BuildContext context) async {
    final price = double.tryParse(_priceCtrl.text);
    final notes = _notesCtrl.text.trim().isNotEmpty
        ? _notesCtrl.text.trim()
        : null;

    await sl<RequestsCubit>().createRequest(
      productType: _selectedType!,
      quantity: _quantity,
      material: _selectedMaterial,
      quality: _selectedQuality,
      targetPrice: price,
      notes: notes,
    );
  }
}

// ─────────────────────────────────────
// STEP BAR WIDGET
// ─────────────────────────────────────
class _StepBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const _StepBar({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: AppColors.surface,
      child: Row(
        children: List.generate(totalSteps * 2 - 1, (i) {
          if (i.isEven) {
            final stepNum = i ~/ 2 + 1;
            final isDone = stepNum < currentStep;
            final isActive = stepNum == currentStep;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: (isDone || isActive)
                    ? AppColors.primary
                    : AppColors.border,
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: isDone
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      )
                    : Text(
                        '$stepNum',
                        style: TextStyle(
                          color: (isActive)
                              ? Colors.white
                              : AppColors.textDisabled,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            );
          } else {
            final lineStep = i ~/ 2 + 1;
            return Expanded(
              child: Container(
                height: 2,
                color: lineStep < currentStep
                    ? AppColors.primary
                    : AppColors.border,
              ),
            );
          }
        }),
      ),
    );
  }
}
