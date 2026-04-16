import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../constants/app_assets.dart';

// ═══════════════════════════════════════════════
// SVG ICON WIDGET
// ═══════════════════════════════════════════════
class SvgIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? color;

  const SvgIcon(
    this.assetPath, {
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}

// ═══════════════════════════════════════════════
// SVG ILLUSTRATION (larger images)
// ═══════════════════════════════════════════════
class SvgIllustration extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SvgIllustration(
    this.assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
    );
  }
}

// ═══════════════════════════════════════════════
// APP LOGO (SVG)
// ═══════════════════════════════════════════════
class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.logo,
      width: size,
      height: size,
    );
  }
}

// ═══════════════════════════════════════════════
// EMPTY STATE WIDGET — with SVG illustration
// ═══════════════════════════════════════════════
class EmptyStateWithIllustration extends StatelessWidget {
  final String illustrationAsset;
  final String title;
  final String subtitle;
  final String? ctaLabel;
  final VoidCallback? onCta;
  final double illustrationSize;

  const EmptyStateWithIllustration({
    super.key,
    required this.illustrationAsset,
    required this.title,
    required this.subtitle,
    this.ctaLabel,
    this.onCta,
    this.illustrationSize = 160,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingXl,
          vertical: AppConstants.spacingLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgIllustration(
              illustrationAsset,
              width: illustrationSize,
              height: illustrationSize,
            ),
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
              SizedBox(
                height: AppConstants.buttonHeight,
                child: ElevatedButton(
                  onPressed: onCta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                  ),
                  child: Text(ctaLabel!, style: context.textStyles.btnText),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// NETWORK ERROR WITH ILLUSTRATION
// ═══════════════════════════════════════════════
class NetworkErrorWithIllustration extends StatelessWidget {
  final VoidCallback onRetry;

  const NetworkErrorWithIllustration({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWithIllustration(
      illustrationAsset: AppAssets.emptyOffline,
      title: 'مفيش اتصال بالإنترنت',
      subtitle: 'تأكد من الاتصال وحاول تاني',
      ctaLabel: 'إعادة المحاولة',
      onCta: onRetry,
    );
  }
}

// ═══════════════════════════════════════════════
// SUCCESS SCREEN WIDGET — with SVG illustration
// ═══════════════════════════════════════════════
class SuccessScreenContent extends StatelessWidget {
  final String illustrationAsset;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const SuccessScreenContent({
    super.key,
    required this.illustrationAsset,
    required this.title,
    required this.subtitle,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIllustration(
            illustrationAsset,
            width: 180,
            height: 180,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(title, style: context.textStyles.h2, textAlign: TextAlign.center),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            subtitle,
            style: context.textStyles.body.copyWith(color: context.colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingLg),
            ...actions,
          ],
        ],
      ),
    );
  }
}
