import 'package:flutter/material.dart';

/// Responsive breakpoints matching common device widths.
/// Usage:  AppResponsive.of(context).isPhone
/// Or:     AppResponsive.isPhoneWidth(MediaQuery.sizeOf(context).width)
class AppResponsive {
  final BuildContext _context;
  AppResponsive._(this._context);

  static AppResponsive of(BuildContext context) => AppResponsive._(context);

  // ── Screen size ─────────────────────────────────────────────────────
  Size get screenSize => MediaQuery.sizeOf(_context);
  double get width     => screenSize.width;
  double get height    => screenSize.height;

  // ── Breakpoints ─────────────────────────────────────────────────────
  /// < 600 dp  — phone portrait
  bool get isPhone    => width < 600;
  /// 600–1024 dp — tablet portrait / phone landscape
  bool get isTablet   => width >= 600 && width < 1024;
  /// ≥ 1024 dp — tablet landscape / desktop
  bool get isDesktop  => width >= 1024;

  // ── Convenience statics ─────────────────────────────────────────────
  static bool isPhoneWidth(double w)   => w < 600;
  static bool isTabletWidth(double w)  => w >= 600 && w < 1024;
  static bool isDesktopWidth(double w) => w >= 1024;

  // ── Content width (max-width for readability on wide screens) ───────
  /// Caps content width at 600 dp on tablets / 420 dp on phones
  double get contentMaxWidth {
    if (isDesktop) return 600;
    if (isTablet)  return 540;
    return width;
  }

  // ── Adaptive grid columns ───────────────────────────────────────────
  int get gridColumns {
    if (isDesktop) return 3;
    if (isTablet)  return 2;
    return 2; // our product-type grid is always 2-3
  }

  // ── Adaptive padding ────────────────────────────────────────────────
  EdgeInsets get pagePadding {
    if (isDesktop || isTablet) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 0);
  }

  // ── Card aspect ratio for product grid ──────────────────────────────
  double get productCardAspect {
    if (isTablet || isDesktop) return 1.3;
    return 1.1;
  }

  // ── Safe area ────────────────────────────────────────────────────────
  EdgeInsets get padding => MediaQuery.paddingOf(_context);
  double get topPadding    => padding.top;
  double get bottomPadding => padding.bottom;

  // ── Font scale (respect system accessibility) ────────────────────────
  double get textScale => MediaQuery.textScalerOf(_context).scale(1.0);

  // ── Platform ─────────────────────────────────────────────────────────
  bool get isIOS     => _platformIs(TargetPlatform.iOS);
  bool get isAndroid => _platformIs(TargetPlatform.android);
  bool get isWeb     {
    try { return identical(0, 0.0); } catch (_) { return false; }
  }

  bool _platformIs(TargetPlatform p) =>
      Theme.of(_context).platform == p;

  // ── Scroll physics (platform-adaptive) ──────────────────────────────
  ScrollPhysics get scrollPhysics {
    return isIOS
        ? const BouncingScrollPhysics()
        : const ClampingScrollPhysics();
  }

  // ── Icon size scaled for tablet ──────────────────────────────────────
  double iconSize(double base) => isTablet || isDesktop ? base * 1.2 : base;
}

/// Centered, max-width content wrapper for tablet/desktop.
/// Wraps [child] in a centered container capped at [maxWidth].
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = 600,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    if (r.isPhone) return child;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null ? Padding(padding: padding!, child: child) : child,
      ),
    );
  }
}

/// Adaptive two-column layout: side-by-side on tablet, stacked on phone.
class ResponsiveTwoColumn extends StatelessWidget {
  final Widget left;
  final Widget right;
  final double spacing;
  final double tabletBreakpoint;

  const ResponsiveTwoColumn({
    super.key,
    required this.left,
    required this.right,
    this.spacing = 16,
    this.tabletBreakpoint = 600,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= tabletBreakpoint) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: left),
              SizedBox(width: spacing),
              Expanded(child: right),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [left, SizedBox(height: spacing), right],
        );
      },
    );
  }
}
