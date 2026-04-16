import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/utils/app_responsive.dart';
import '../cubit/auth_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthCubit>(),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatefulWidget {
  const _ProfileBody();

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  String _businessName = '...';
  String _role = '';
  String _avatar = 'M';
  String? _avatarUrl;
  bool _loading = true;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final svc = sl<UserService>();
    final profile = await svc.getProfile(forceRefresh: true);
    if (!mounted) return;

    final role = profile?['role'] as String? ?? '';
    final avatarUrl = profile?['avatar_url'] as String?;
    final businessName = await svc.businessName;

    final name = profile?['name'] as String? ?? 'M';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'M';

    setState(() {
      _businessName = businessName;
      _role = role;
      _avatar = initial;
      _avatarUrl = avatarUrl;
      _loading = false;
    });
  }

  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (picked == null || !mounted) return;

    setState(() => _uploading = true);

    final svc = sl<UserService>();
    final url = await svc.uploadAvatar(picked.path);

    if (!mounted) return;

    if (url != null) {
      setState(() {
        _avatarUrl = url;
        _uploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم تحديث الصورة بنجاح ✅'),
            backgroundColor: context.colors.success,
          ),
        );
      }
    } else {
      setState(() => _uploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل في رفع الصورة، حاول مرة أخرى'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل الخروج', textAlign: TextAlign.right),
        content: const Text(
          'هل أنت متأكد أنك تريد تسجيل الخروج؟',
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().signOut();
            },
            child: const Text(
              'تسجيل خروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('⚠️ حذف الحساب نهائياً'),
          ],
        ),
        content: const Text(
          'هل أنت متأكد إنك عايز تحذف حسابك؟\n\n'
          'هيتم حذف كل بياناتك بشكل نهائي ومش هتقدر تسترجعها تاني.\n\n'
          'ده يشمل:\n'
          '• بيانات الحساب الشخصية\n'
          '• جميع الطلبات والعروض\n'
          '• إعدادات المصنع / البراند',
          textAlign: TextAlign.right,
          style: TextStyle(height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Second confirmation
              _confirmDeleteAccount();
            },
            child: const Text(
              'حذف الحساب',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          '⛔ تأكيد الحذف النهائي',
          textAlign: TextAlign.right,
        ),
        content: const Text(
          'هذا الإجراء لا يمكن التراجع عنه.\nهل تريد المتابعة؟',
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('لا، تراجع'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().deleteAccount();
            },
            child: const Text('نعم، احذف حسابي'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleLabel = _role == 'factory' ? 'مصنع' : 'براند';

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRoutes.splash);
        }
        if (state is AuthAccountDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('تم حذف حسابك بنجاح'),
              backgroundColor: context.colors.success,
            ),
          );
          context.go(AppRoutes.splash);
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(title: const Text('حسابي'), centerTitle: true),
        body: ResponsiveCenter(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Profile Header
                      Center(
                        child: Column(
                          children: [
                            // ── Avatar with upload ──
                            GestureDetector(
                              onTap: _uploading ? null : _pickAndUploadAvatar,
                              child: Stack(
                                children: [
                                  // Avatar circle
                                  Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: _avatarUrl == null
                                          ? LinearGradient(
                                              colors: [
                                                context.colors.primary,
                                                context.colors.primaryLight,
                                              ],
                                            )
                                          : null,
                                      boxShadow: [
                                        BoxShadow(
                                          color: context.colors.primary
                                              .withValues(alpha: 0.2),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: _uploading
                                          ? Container(
                                              color: context.colors.primary
                                                  .withValues(alpha: 0.7),
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.5,
                                                ),
                                              ),
                                            )
                                          : _avatarUrl != null &&
                                                  _avatarUrl!.isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl: _avatarUrl!,
                                                  width: 110,
                                                  height: 110,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context,
                                                          url) =>
                                                      Container(
                                                    color: context.colors.primary,
                                                    child: Center(
                                                      child: Text(
                                                        _avatar,
                                                        style:
                                                            const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget: (context,
                                                          url, error) =>
                                                      Container(
                                                    color: context.colors.primary,
                                                    child: Center(
                                                      child: Text(
                                                        _avatar,
                                                        style:
                                                            const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Center(
                                                  child: Text(
                                                    _avatar,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                    ),
                                  ),
                                  // Camera overlay icon
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: context.colors.primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.15),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Business Name
                            Text(_businessName, style: context.textStyles.h3),
                            const SizedBox(height: 4),
                            // Role badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.primaryPale,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.radiusPill,
                                ),
                              ),
                              child: Text(
                                roleLabel,
                                style: context.textStyles.caption.copyWith(
                                  color: context.colors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Settings List
                      AppCard(
                        child: Column(
                          children: [
                            _ProfileMenuItem(
                              icon: Icons.person_outline_rounded,
                              title: 'تعديل الملف الشخصي',
                              onTap: () => context.push(AppRoutes.editProfile),
                            ),
                            const Divider(),
                            _ProfileMenuItem(
                              icon: Icons.notifications_none_rounded,
                              title: 'التنبيهات',
                              onTap: () =>
                                  context.push(AppRoutes.notifications),
                            ),
                            const Divider(),
                            _ProfileMenuItem(
                              icon: Icons.security_rounded,
                              title: 'الخصوصية والأمان',
                              onTap: () =>
                                  context.push(AppRoutes.privacySecurity),
                            ),
                            const Divider(),
                            _ProfileMenuItem(
                              icon: Icons.help_outline_rounded,
                              title: 'المساعدة والدعم',
                              onTap: () => context.push(AppRoutes.helpSupport),
                            ),
                            const Divider(),
                            _ProfileMenuItem(
                              icon: Icons.logout_rounded,
                              title: 'تسجيل الخروج',
                              titleColor: Colors.red,
                              iconColor: Colors.red,
                              onTap: _logout,
                            ),
                            const Divider(),
                            _ProfileMenuItem(
                              icon: Icons.delete_forever_rounded,
                              title: 'حذف الحساب',
                              titleColor: const Color(0xFF8B0000),
                              iconColor: const Color(0xFF8B0000),
                              onTap: _deleteAccount,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'v1.0.0',
                        style: context.textStyles.caption.copyWith(
                          color: context.colors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? context.colors.primary),
      title: Text(
        title,
        style: context.textStyles.body.copyWith(
          color: titleColor ?? context.colors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}
