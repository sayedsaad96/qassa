import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/utils/app_responsive.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _loading = true;
  bool _saving = false;
  String _role = '';

  // Common fields
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  // Brand fields
  final _brandNameCtrl = TextEditingController();
  final _brandCategoryCtrl = TextEditingController();
  final _brandCityCtrl = TextEditingController();
  final _brandWebsiteCtrl = TextEditingController();
  final _brandDescriptionCtrl = TextEditingController();

  // Factory fields
  final _factoryNameCtrl = TextEditingController();
  final _factoryCityCtrl = TextEditingController();
  final _minQuantityCtrl = TextEditingController();
  final _leadTimeCtrl = TextEditingController();
  final _factoryDescriptionCtrl = TextEditingController();
  List<String> _selectedSpecialties = [];

  final _allSpecialties = [
    'تيشيرت',
    'جينز',
    'فستان',
    'هوودي',
    'قميص',
    'بنطلون',
    'جاكيت',
    'ملابس أطفال',
    'ملابس رياضية',
    'ملابس رسمية',
    'ملابس داخلية',
    'ملابس سباحة',
    'ملابس محجبات',
    'اخرى',
  ];

  final _cities = [
    'القاهرة',
    'الإسكندرية',
    'المحلة الكبرى',
    'شبرا الخيمة',
    '6 أكتوبر',
    '10 رمضان',
    'بورسعيد',
    'المنصورة',
    'طنطا',
    'دمياط',
    'أسيوط',
    'الفيوم',
    'الزقازيق',
    'المنوفية',
    'المنيا',
    'الاسماعيلية',
    'السويس',
    'بني سويف',
    'سوهاج',
    'قنا',
    'الأقصر',
    'أسوان',
    'البحر الأحمر',
    'مطروح',
    'شمال سيناء',
    'جنوب سيناء',
    'أخرى',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _brandNameCtrl.dispose();
    _brandCategoryCtrl.dispose();
    _brandCityCtrl.dispose();
    _brandWebsiteCtrl.dispose();
    _brandDescriptionCtrl.dispose();
    _factoryNameCtrl.dispose();
    _factoryCityCtrl.dispose();
    _minQuantityCtrl.dispose();
    _leadTimeCtrl.dispose();
    _factoryDescriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final svc = sl<UserService>();
    final profile = await svc.getProfile(forceRefresh: true);
    if (!mounted || profile == null) return;

    _role = profile['role'] as String? ?? '';
    _nameCtrl.text = profile['name'] as String? ?? '';
    _phoneCtrl.text = profile['phone'] as String? ?? '';

    if (_role == 'brand') {
      _brandNameCtrl.text = profile['brand_name'] as String? ?? '';
      _brandCategoryCtrl.text = profile['brand_category'] as String? ?? '';
      _brandCityCtrl.text = profile['city'] as String? ?? '';
      _brandWebsiteCtrl.text = profile['website'] as String? ?? '';
      _brandDescriptionCtrl.text = profile['description'] as String? ?? '';
    } else if (_role == 'factory') {
      final factory = await svc.getFactoryProfile(forceRefresh: true);
      if (factory != null) {
        _factoryNameCtrl.text = factory['name'] as String? ?? '';
        _factoryCityCtrl.text = factory['city'] as String? ?? '';
        _minQuantityCtrl.text = '${factory['min_quantity'] ?? 100}';
        _leadTimeCtrl.text = '${factory['lead_time_days'] ?? 21}';
        _factoryDescriptionCtrl.text = factory['description'] as String? ?? '';
        final specs = factory['specialties'];
        if (specs is List) {
          _selectedSpecialties = specs.cast<String>().toList();
        }
      }
    }

    setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);

    final svc = sl<UserService>();
    bool success = true;

    // Update user profile
    final userData = <String, dynamic>{
      'name': _nameCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
    };

    if (_role == 'brand') {
      userData['brand_name'] = _brandNameCtrl.text.trim();
      userData['brand_category'] = _brandCategoryCtrl.text.trim();
      userData['city'] = _brandCityCtrl.text.trim();
      userData['website'] = _brandWebsiteCtrl.text.trim();
      userData['description'] = _brandDescriptionCtrl.text.trim();
    }

    success = await svc.updateProfile(userData);

    // Update factory profile if factory role
    if (success && _role == 'factory') {
      final factoryData = <String, dynamic>{
        'name': _factoryNameCtrl.text.trim(),
        'city': _factoryCityCtrl.text.trim(),
        'min_quantity': int.tryParse(_minQuantityCtrl.text) ?? 100,
        'lead_time_days': int.tryParse(_leadTimeCtrl.text) ?? 21,
        'specialties': _selectedSpecialties,
        'description': _factoryDescriptionCtrl.text.trim(),
      };
      success = await svc.updateFactoryProfile(factoryData);
    }

    if (!mounted) return;
    setState(() => _saving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم حفظ التعديلات بنجاح ✅'),
          backgroundColor: context.colors.success,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل في حفظ التعديلات، حاول مرة أخرى'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي'),
        actions: [
          if (!_loading)
            TextButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'حفظ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
        ],
      ),
      body: ResponsiveCenter(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Common Section ──
                    _SectionHeader(
                      title: 'البيانات الأساسية',
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 12),
                    AppCard(
                      child: Column(
                        children: [
                          _FormField(
                            label: 'الاسم الشخصي',
                            controller: _nameCtrl,
                            icon: Icons.badge_outlined,
                            hint: 'مثال: أحمد محمد',
                          ),
                          const SizedBox(height: 16),
                          _FormField(
                            label: 'رقم الهاتف',
                            controller: _phoneCtrl,
                            icon: Icons.phone_outlined,
                            hint: '01xxxxxxxxx',
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Role-specific section ──
                    if (_role == 'brand') ..._buildBrandFields(),
                    if (_role == 'factory') ..._buildFactoryFields(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  List<Widget> _buildBrandFields() {
    return [
      _SectionHeader(
        title: 'بيانات البراند 🏷',
        icon: Icons.storefront_rounded,
      ),
      const SizedBox(height: 12),
      AppCard(
        child: Column(
          children: [
            _FormField(
              label: 'اسم البراند',
              controller: _brandNameCtrl,
              icon: Icons.store_rounded,
              hint: 'مثال: Qassa Wear',
            ),
            const SizedBox(height: 16),
            _FormField(
              label: 'تصنيف البراند',
              controller: _brandCategoryCtrl,
              icon: Icons.category_outlined,
              hint: 'مثال: ملابس كاجوال، ملابس رياضية',
            ),
            const SizedBox(height: 16),
            _DropdownField(
              label: 'المدينة',
              value: _brandCityCtrl.text.isEmpty ? null : _brandCityCtrl.text,
              items: _cities,
              icon: Icons.location_on_outlined,
              onChanged: (v) => setState(() => _brandCityCtrl.text = v ?? ''),
            ),
            const SizedBox(height: 16),
            _FormField(
              label: 'الموقع الإلكتروني (اختياري)',
              controller: _brandWebsiteCtrl,
              icon: Icons.language_rounded,
              hint: 'www.example.com',
              keyboardType: TextInputType.url,
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      AppCard(
        child: _FormField(
          label: 'وصف البراند',
          controller: _brandDescriptionCtrl,
          icon: Icons.description_outlined,
          hint: 'اكتب نبذة عن البراند...',
          maxLines: 4,
        ),
      ),
    ];
  }

  List<Widget> _buildFactoryFields() {
    return [
      _SectionHeader(title: 'بيانات المصنع 🏭', icon: Icons.factory_rounded),
      const SizedBox(height: 12),
      AppCard(
        child: Column(
          children: [
            _FormField(
              label: 'اسم المصنع',
              controller: _factoryNameCtrl,
              icon: Icons.factory_rounded,
              hint: 'مثال: مصنع النجاح للملابس',
            ),
            const SizedBox(height: 16),
            _DropdownField(
              label: 'المدينة',
              value: _factoryCityCtrl.text.isEmpty
                  ? null
                  : _factoryCityCtrl.text,
              items: _cities,
              icon: Icons.location_on_outlined,
              onChanged: (v) => setState(() => _factoryCityCtrl.text = v ?? ''),
            ),
            const SizedBox(height: 16),
            _FormField(
              label: 'الحد الأدنى للكمية',
              controller: _minQuantityCtrl,
              icon: Icons.inventory_2_outlined,
              hint: '100',
              keyboardType: TextInputType.number,
              suffix: 'قطعة',
            ),
            const SizedBox(height: 16),
            _FormField(
              label: 'مدة التسليم',
              controller: _leadTimeCtrl,
              icon: Icons.schedule_outlined,
              hint: '21',
              keyboardType: TextInputType.number,
              suffix: 'يوم',
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),

      // Specialties
      _SectionHeader(title: 'التخصصات 👕', icon: Icons.checkroom_rounded),
      const SizedBox(height: 12),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اختر تخصصات المصنع:',
              style: context.textStyles.bodySm.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allSpecialties.map((s) {
                final selected = _selectedSpecialties.contains(s);
                return FilterChip(
                  label: Text(s),
                  selected: selected,
                  selectedColor: context.colors.primaryPale,
                  checkmarkColor: context.colors.primary,
                  backgroundColor: context.colors.surface,
                  side: BorderSide(
                    color: selected ? context.colors.primary : context.colors.border,
                  ),
                  labelStyle: context.textStyles.bodySm.copyWith(
                    color: selected
                        ? context.colors.primary
                        : context.colors.textSecondary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                  ),
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        _selectedSpecialties.add(s);
                      } else {
                        _selectedSpecialties.remove(s);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      AppCard(
        child: _FormField(
          label: 'وصف المصنع',
          controller: _factoryDescriptionCtrl,
          icon: Icons.description_outlined,
          hint: 'اكتب نبذة عن المصنع وخبرتك في التصنيع...',
          maxLines: 4,
        ),
      ),
    ];
  }
}

// ════════════════════════════════════
// SECTION HEADER
// ════════════════════════════════════
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: context.colors.primaryPale,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: context.colors.primary, size: 18),
        ),
        const SizedBox(width: 10),
        Text(title, style: context.textStyles.h5),
      ],
    );
  }
}

// ════════════════════════════════════
// FORM FIELD
// ════════════════════════════════════
class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? suffix;

  const _FormField({
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyles.label.copyWith(color: context.colors.textSecondary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          textAlign: TextAlign.right,
          style: context.textStyles.body,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: context.textStyles.bodySm.copyWith(
              color: context.colors.textDisabled,
            ),
            prefixIcon: Icon(icon, color: context.colors.primary, size: 20),
            suffixText: suffix,
            suffixStyle: context.textStyles.bodySm.copyWith(
              color: context.colors.textSecondary,
            ),
            filled: true,
            fillColor: context.colors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide(color: context.colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide(color: context.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide(
                color: context.colors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════
// DROPDOWN FIELD
// ════════════════════════════════════
class _DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textStyles.label.copyWith(color: context.colors.textSecondary),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: items.contains(value) ? value : null,
          isExpanded: true,
          style: context.textStyles.body,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: context.colors.primary, size: 20),
            filled: true,
            fillColor: context.colors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide(color: context.colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide(color: context.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide(
                color: context.colors.primary,
                width: 1.5,
              ),
            ),
          ),
          items: items
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
