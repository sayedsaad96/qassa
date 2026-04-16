import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/performance_utils.dart';

void main() {
  // Catch all async errors in Zone
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // ── System UI ─────────────────────────────────────────
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // ── Performance ───────────────────────────────────────
    await configurePerformance();

    // ── Env ───────────────────────────────────────────────
    await dotenv.load(fileName: '.env');

    // ── Supabase ──────────────────────────────────────────
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );

    // ── DI ────────────────────────────────────────────────
    await configureDependencies();

    runApp(const QassaApp());
  }, (error, stack) {
    // Global error handler — log or report to Sentry in production
    debugPrint('❌ Uncaught error: $error\n$stack');
  });
}

class QassaApp extends StatelessWidget {
  const QassaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Qassa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      // ── RTL ──────────────────────────────────────────────
      builder: (context, child) {
        return MediaQuery(
          // Clamp text scale to [0.85, 1.3] to prevent layout breaks
          // while still respecting user accessibility preferences
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.85, 1.30),
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
