import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';

import '../constants/app_constants.dart';


// ═══════════════════════════════════════════════
// APP BUTTON
// ═══════════════════════════════════════════════
enum AppButtonVariant { primary, outline, ghost, success, accent, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool fullWidth;
  final double? height;
  final double? fontSize;
  final IconData? icon;
  final Widget? leadingWidget;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.height,
    this.fontSize,
    this.icon,
    this.leadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final h = height ?? AppConstants.buttonHeight;

    Widget child = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingWidget != null) ...[
                leadingWidget!,
                const SizedBox(width: 6),
              ] else if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: context.textStyles.btnText.copyWith(
                  fontSize: fontSize,
                  color: _getTextColor(context),
                ),
              ),
            ],
          );

    switch (variant) {
      case AppButtonVariant.primary:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: h,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              elevation: 0,
              disabledBackgroundColor: context.colors.primaryLight.withValues(alpha: 0.5),
            ),
            child: child,
          ),
        );
      case AppButtonVariant.outline:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: h,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.primary,
              side: BorderSide(color: context.colors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
            ),
            child: child,
          ),
        );
      case AppButtonVariant.ghost:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: h,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: context.colors.textSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
            ),
            child: child,
          ),
        );
      case AppButtonVariant.success:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: h,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              elevation: 0,
            ),
            child: child,
          ),
        );
      case AppButtonVariant.accent:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: h,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              elevation: 0,
            ),
            child: child,
          ),
        );
      case AppButtonVariant.danger:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: h,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              elevation: 0,
            ),
            child: child,
          ),
        );
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (variant) {
      case AppButtonVariant.outline:
        return context.colors.primary;
      case AppButtonVariant.ghost:
        return context.colors.textSecondary;
      default:
        return Colors.white;
    }
  }
}

// ═══════════════════════════════════════════════
// APP TEXT FIELD
// ═══════════════════════════════════════════════
class AppTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final Widget? suffix;
  final Widget? prefix;
  final void Function(String)? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final bool enabled;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    required this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.suffix,
    this.prefix,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.textInputAction,
    this.enabled = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      textInputAction: textInputAction,
      enabled: enabled,
      focusNode: focusNode,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: context.textStyles.body,
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: TextDirection.rtl,
        suffixIcon: suffix,
        prefixIcon: prefix,
        counterText: '',
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// LOADING WIDGET
// ═══════════════════════════════════════════════
class AppLoading extends StatelessWidget {
  final String? message;
  final Color? color;

  const AppLoading({super.key, this.message, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: color ?? context.colors.primary,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: context.textStyles.body.copyWith(color: context.colors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// EMPTY STATE WIDGET
// ═══════════════════════════════════════════════
class EmptyStateWidget extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String? ctaLabel;
  final VoidCallback? onCta;

  const EmptyStateWidget({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.ctaLabel,
    this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              title,
              style: context.textStyles.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              subtitle,
              style: context.textStyles.body.copyWith(color: context.colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (ctaLabel != null && onCta != null) ...[
              const SizedBox(height: AppConstants.spacingLg),
              AppButton(
                label: ctaLabel!,
                onPressed: onCta,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// APP SNACK BAR
// ═══════════════════════════════════════════════
class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('✅ ', style: TextStyle(fontSize: 16)),
            Expanded(child: Text(message, style: context.textStyles.body.copyWith(color: Colors.white))),
          ],
        ),
        backgroundColor: context.colors.success,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('❌ ', style: TextStyle(fontSize: 16)),
            Expanded(child: Text(message, style: context.textStyles.body.copyWith(color: Colors.white))),
          ],
        ),
        backgroundColor: context.colors.error,
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('💡 ', style: TextStyle(fontSize: 16)),
            Expanded(child: Text(message, style: context.textStyles.body.copyWith(color: Colors.white))),
          ],
        ),
        backgroundColor: context.colors.primary,
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// APP CARD
// ═══════════════════════════════════════════════
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? borderColor;
  final EdgeInsets? padding;
  final double? borderWidth;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderColor,
    this.padding,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: borderColor ?? context.colors.border,
            width: borderWidth ?? 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: padding ?? const EdgeInsets.all(AppConstants.spacingMd),
        child: child,
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// APP CHIP
// ═══════════════════════════════════════════════
class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Color? selectedColor;
  final Color? textColor;

  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.selectedColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = selected
        ? (selectedColor ?? context.colors.primary)
        : context.colors.background;
    final fgColor = selected ? Colors.white : (textColor ?? context.colors.textSecondary);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusPill),
          border: Border.all(
            color: selected ? Colors.transparent : context.colors.border,
          ),
        ),
        child: Text(
          label,
          style: context.textStyles.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: fgColor,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// GRADIENT HEADER
// ═══════════════════════════════════════════════
class GradientHeader extends StatelessWidget {
  final Widget child;
  final double? height;

  const GradientHeader({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D2260), context.colors.primary],
        ),
      ),
      child: child,
    );
  }
}

// ═══════════════════════════════════════════════
// SECTION TITLE
// ═══════════════════════════════════════════════
class SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppConstants.spacingSm,
        top: AppConstants.spacingMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: context.textStyles.label.copyWith(fontWeight: FontWeight.w700)),
          if (trailing != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: Text(
                trailing!,
                style: context.textStyles.caption.copyWith(color: context.colors.primary),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// STAT CARD
// ═══════════════════════════════════════════════
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 6,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: context.textStyles.h1.copyWith(
                color: valueColor ?? context.colors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: context.textStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// NETWORK ERROR WIDGET
// ═══════════════════════════════════════════════
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NetworkErrorWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      emoji: '⚡',
      title: 'مفيش اتصال بالإنترنت',
      subtitle: 'تأكد من الاتصال وحاول تاني',
      ctaLabel: 'إعادة المحاولة',
      onCta: onRetry,
    );
  }
}
