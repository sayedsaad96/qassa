import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qassa/core/theme/theme_context_extension.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ═══════════════════════════════════════════════
// DEBOUNCER — prevents rapid successive calls
// (e.g. search-as-you-type, filter changes)
// ═══════════════════════════════════════════════
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 350});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void cancel() => _timer?.cancel();
}

// ═══════════════════════════════════════════════
// CACHED NETWORK IMAGE WRAPPER
// Consistent placeholder + error UI across the app
// ═══════════════════════════════════════════════
class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;
  final Color? placeholderColor;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
    this.placeholderColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _Placeholder(
        width: width,
        height: height,
        color: placeholderColor,
      ),
      errorWidget: (context, url, error) =>
          errorWidget ?? _ErrorPlaceholder(width: width, height: height),
      // Memory optimisation: limit cache size
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}

class _Placeholder extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const _Placeholder({this.width, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: color ?? context.colors.background,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: context.colors.primaryLight,
          ),
        ),
      ),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  const _ErrorPlaceholder({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: context.colors.background,
      child: Icon(Icons.broken_image_rounded,
          color: context.colors.textDisabled, size: 28),
    );
  }
}

// ═══════════════════════════════════════════════
// APP PERFORMANCE CONFIG
// Call once in main() before runApp()
// ═══════════════════════════════════════════════
Future<void> configurePerformance() async {
  // Limit image cache memory to 100MB (default is unlimited)
  PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20;
  // Limit cache entry count
  PaintingBinding.instance.imageCache.maximumSize = 150;

  // Prefer 60fps scheduling hint on high-refresh devices
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

// ═══════════════════════════════════════════════
// KEEP-ALIVE WRAPPER
// Prevents tab content from rebuilding on tab switch
// ═══════════════════════════════════════════════
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

// ═══════════════════════════════════════════════
// SLIVER APP BAR DELEGATE
// Reusable for pinned section headers in CustomScrollView
// ═══════════════════════════════════════════════
class SliverPinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  const SliverPinnedHeaderDelegate({
    required this.height,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => height;
  @override
  double get minExtent => height;
  @override
  bool shouldRebuild(SliverPinnedHeaderDelegate old) =>
      old.height != height || old.child != child;
}
