import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/user_service.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/utils/performance_utils.dart';
import '../../domain/entities/factory_profile_entity.dart';
import '../../domain/entities/upload_image_params.dart';
import '../cubit/factory_profile_cubit.dart';

class FactoryProfileSetupPage extends StatefulWidget {
  const FactoryProfileSetupPage({super.key});

  @override
  State<FactoryProfileSetupPage> createState() =>
      _FactoryProfileSetupPageState();
}

class _FactoryProfileSetupPageState extends State<FactoryProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _specialtiesCtrl = TextEditingController();
  final _minQtyCtrl = TextEditingController();
  final _leadTimeCtrl = TextEditingController();

  bool _isEditing = false;
  String? _existingProfileId;
  List<String> _existingImages = [];
  final List<XFile> _newImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    final userService = sl<UserService>();
    final ownerId = userService.currentUserId;
    if (ownerId == null) return;

    // Load the profile via cubit using sl since context doesn't have the provider here
    sl<FactoryProfileCubit>().loadProfile(ownerId);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    _specialtiesCtrl.dispose();
    _minQtyCtrl.dispose();
    _leadTimeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    final city = _cityCtrl.text.trim();
    final specialties = _specialtiesCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final minQty = int.parse(_minQtyCtrl.text.trim());
    final leadTime = int.parse(_leadTimeCtrl.text.trim());

    final userService = sl<UserService>();
    final ownerId = userService.currentUserId;

    if (ownerId == null) {
      AppSnackBar.showError(context, 'يجب تسجيل الدخول أولاً');
      return;
    }

    final entity = FactoryProfileEntity(
      id: _isEditing ? _existingProfileId! : const Uuid().v4(),
      ownerId: ownerId,
      name: name,
      city: city,
      specialties: specialties.isEmpty ? ['عام'] : specialties,
      minQuantity: minQty,
      leadTimeDays: leadTime,
      rating: 5.0,
      reviewCount: 0,
      portfolioImages: _existingImages,
      isFastResponder: true,
    );

    final List<UploadImageParams> uploadParams = [];
    for (var file in _newImages) {
      final bytes = await file.readAsBytes();
      uploadParams.add(UploadImageParams(fileName: file.name, bytes: bytes));
    }

    if (!mounted) return;

    if (_isEditing) {
      sl<FactoryProfileCubit>().updateProfile(entity, newImages: uploadParams);
    } else {
      sl<FactoryProfileCubit>().createProfile(entity, newImages: uploadParams);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<FactoryProfileCubit>(),
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          title: const Text('إعداد البروفايل'),
          backgroundColor: context.colors.background,
        ),
        body: BlocConsumer<FactoryProfileCubit, FactoryProfileState>(
          listener: (context, state) {
            if (state is FactoryProfileLoaded) {
              _isEditing = true;
              _isEditing = true;
              _existingProfileId = state.profile.id;
              _existingImages = List<String>.from(
                state.profile.portfolioImages,
              );
              _nameCtrl.text = state.profile.name;
              _cityCtrl.text = state.profile.city;
              _specialtiesCtrl.text = state.profile.specialties.join(', ');
              _minQtyCtrl.text = state.profile.minQuantity.toString();
              _leadTimeCtrl.text = state.profile.leadTimeDays.toString();
            } else if (state is FactoryProfileCreated ||
                state is FactoryProfileUpdated) {
              // Refresh user service cache so dashboard gets fresh data
              sl<UserService>().clearCache();
              context.go(AppRoutes.factoryDashboard);
            } else if (state is FactoryProfileError) {
              AppSnackBar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is FactoryProfileLoading;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                children: [
                  const SectionTitle(title: 'معلومات المصنع الأساسية'),
                  const SizedBox(height: 8),
                  AppTextField(
                    controller: _nameCtrl,
                    hint: 'اسم المصنع',
                    validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _cityCtrl,
                    hint: 'المدينة (مثل: القاهرة، المحلة)',
                    validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _specialtiesCtrl,
                    hint: 'التخصصات (مفصولة بفاصلة، مثل: تيشرتات، بنطلونات)',
                    validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                  ),
                  const SizedBox(height: 24),

                  const SectionTitle(title: 'تفاصيل الإنتاج'),
                  const SizedBox(height: 8),
                  AppTextField(
                    controller: _minQtyCtrl,
                    hint: 'الحد الأدنى للكمية (قطعة)',
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'مطلوب';
                      if (int.tryParse(v) == null) return 'رقم غير صحيح';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _leadTimeCtrl,
                    hint: 'مدة التنفيذ القياسية (بالأيام)',
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'مطلوب';
                      if (int.tryParse(v) == null) return 'رقم غير صحيح';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  const SectionTitle(title: 'معرض الأعمال (اختياري)'),
                  const SizedBox(height: 8),
                  _buildPortfolioImages(),
                  const SizedBox(height: 32),

                  AppButton(
                    label: _isEditing ? 'حفظ التعديلات' : 'حفظ ومتابعة',
                    isLoading: isLoading,
                    onPressed: _submit,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortfolioImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_existingImages.isNotEmpty || _newImages.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _existingImages.length + _newImages.length,
            itemBuilder: (context, index) {
              if (index < _existingImages.length) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    AppNetworkImage(
                      url: _existingImages[index],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _existingImages.removeAt(index);
                          });
                        },
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.close, size: 16, color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                final localIndex = index - _existingImages.length;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: FutureBuilder<Uint8List>(
                        future: _newImages[localIndex].readAsBytes(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            );
                          }
                          return Container(
                            color: context.colors.primaryPale,
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _newImages.removeAt(localIndex);
                          });
                        },
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.close, size: 16, color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        if (_existingImages.isNotEmpty || _newImages.isNotEmpty)
          const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('إضافة صور جديدة'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            foregroundColor: context.colors.primary,
            side: BorderSide(color: context.colors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _newImages.addAll(pickedFiles);
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'حدث خطأ أثناء التقاط الصور');
      }
    }
  }
}