import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/di/injection.dart';
import '../cubit/auth_cubit.dart';

// ═══════════════════════════════════════════════
// EMAIL AUTH PAGE (Sign Up)
// ═══════════════════════════════════════════════
class EmailAuthPage extends StatelessWidget {
  final String role;
  const EmailAuthPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthCubit>(),
      child: _EmailAuthBody(role: role),
    );
  }
}

class _EmailAuthBody extends StatefulWidget {
  final String role;
  const _EmailAuthBody({required this.role});

  @override
  State<_EmailAuthBody> createState() => _EmailAuthBodyState();
}

class _EmailAuthBodyState extends State<_EmailAuthBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  bool _obscurePassword = true;

  bool get isBrand => widget.role == 'brand';

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<AuthCubit>();
    cubit.signUp(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      name: _nameCtrl.text.trim(),
      role: widget.role,
      brandName: isBrand ? _brandCtrl.text.trim() : null,
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    _brandCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        title: const Text('إنشاء حساب'),
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.roleSelection);
            }
          },
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            if (state.user.isBrand) {
              context.go(AppRoutes.brandHome);
            } else {
              context.go(AppRoutes.factoryDashboard);
            }
          } else if (state is AuthError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text('ادخل بياناتك', style: context.textStyles.h2),
                  const SizedBox(height: 6),
                  Text(
                    'سجل حسابك بالإيميل والباسورد',
                    style: context.textStyles.body.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Name
                  Text('اسمك', style: context.textStyles.label),
                  const SizedBox(height: 6),
                  AppTextField(
                    hint: 'الاسم الأول والأخير',
                    controller: _nameCtrl,
                    keyboardType: TextInputType.name,
                    validator: (v) =>
                        (v?.trim().isEmpty ?? true) ? 'ادخل اسمك' : null,
                  ),
                  const SizedBox(height: 14),

                  // Brand name (brand only)
                  if (isBrand) ...[
                    Text('اسم البراند', style: context.textStyles.label),
                    const SizedBox(height: 6),
                    AppTextField(
                      hint: 'مثال: Nova',
                      controller: _brandCtrl,
                      validator: (v) => (v?.trim().isEmpty ?? true)
                          ? 'ادخل اسم البراند'
                          : null,
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Email
                  Text('الإيميل', style: context.textStyles.label),
                  const SizedBox(height: 6),
                  AppTextField(
                    hint: 'example@email.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'ادخل الإيميل';
                      }
                      if (!RegExp(
                        r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,}$',
                      ).hasMatch(v.trim())) {
                        return 'الإيميل مش صح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Password
                  Text('الباسورد', style: context.textStyles.label),
                  const SizedBox(height: 6),
                  AppTextField(
                    hint: '6 حروف أو أكتر',
                    controller: _passwordCtrl,
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: context.colors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'ادخل الباسورد';
                      }
                      if (v.length < 6) {
                        return 'الباسورد لازم يكون 6 حروف على الأقل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        label: 'إنشاء حساب ←',
                        onPressed: _submit,
                        isLoading: state is AuthLoading,
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'عندك حساب؟ ',
                        style: context.textStyles.body.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(
                          '${AppRoutes.login}?role=${widget.role}',
                        ),
                        child: Text(
                          'سجل دخول',
                          style: context.textStyles.body.copyWith(
                            color: context.colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// LOGIN PAGE (Sign In)
// ═══════════════════════════════════════════════
class LoginPage extends StatelessWidget {
  final String role;
  const LoginPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthCubit>(),
      child: _LoginBody(role: role),
    );
  }
}

class _LoginBody extends StatefulWidget {
  final String role;
  const _LoginBody({required this.role});

  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<AuthCubit>();
    cubit.signIn(email: _emailCtrl.text.trim(), password: _passwordCtrl.text);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        title: const Text('تسجيل دخول'),
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.roleSelection);
            }
          },
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            if (state.user.isBrand) {
              context.go(AppRoutes.brandHome);
            } else {
              context.go(AppRoutes.factoryDashboard);
            }
          } else if (state is AuthError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text('أهلاً بيك تاني', style: context.textStyles.h2),
                  const SizedBox(height: 6),
                  Text(
                    'سجل دخولك بالإيميل والباسورد',
                    style: context.textStyles.body.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Email
                  Text('الإيميل', style: context.textStyles.label),
                  const SizedBox(height: 6),
                  AppTextField(
                    hint: 'example@email.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'ادخل الإيميل';
                      }
                      if (!RegExp(
                        r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,}$',
                      ).hasMatch(v.trim())) {
                        return 'الإيميل مش صح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Password
                  Text('الباسورد', style: context.textStyles.label),
                  const SizedBox(height: 6),
                  AppTextField(
                    hint: 'ادخل الباسورد',
                    controller: _passwordCtrl,
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: context.colors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'ادخل الباسورد';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        label: 'تسجيل دخول ←',
                        onPressed: _submit,
                        isLoading: state is AuthLoading,
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'مالكش حساب؟ ',
                        style: context.textStyles.body.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(
                          '${AppRoutes.emailAuth}?role=${widget.role}',
                        ),
                        child: Text(
                          'سجل حساب جديد',
                          style: context.textStyles.body.copyWith(
                            color: context.colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
