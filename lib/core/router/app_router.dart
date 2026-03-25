import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/role_selection_page.dart';
import '../../features/auth/presentation/pages/email_auth_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/brand/presentation/pages/brand_shell_page.dart';
import '../../features/brand/presentation/pages/brand_home_page.dart';
import '../../features/brand/presentation/pages/factories_list_page.dart';
import '../../features/brand/presentation/pages/factory_details_page.dart';
import '../../features/brand/presentation/pages/create_request_page.dart';
import '../../features/brand/presentation/pages/my_requests_page.dart';
import '../../features/brand/presentation/pages/offers_page.dart';
import '../../features/brand/presentation/pages/order_summary_page.dart';
import '../../features/brand/presentation/pages/wa_handoff_page.dart';
import '../../features/brand/presentation/pages/notif_prime_page.dart';
import '../../features/factory/presentation/pages/factory_shell_page.dart';
import '../../features/factory/presentation/pages/factory_dashboard_page.dart';
import '../../features/factory/presentation/pages/factory_requests_page.dart';
import '../../features/factory/presentation/pages/request_detail_page.dart';
import '../../features/factory/presentation/pages/send_offer_page.dart';
import '../../features/factory/presentation/pages/factory_offers_page.dart';
import '../../features/factory/presentation/pages/factory_profile_setup_page.dart';

import '../../features/auth/presentation/pages/edit_profile_page.dart';
import '../../features/auth/presentation/pages/notifications_settings_page.dart';
import '../../features/auth/presentation/pages/privacy_security_page.dart';
import '../../features/auth/presentation/pages/help_support_page.dart';

abstract class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String emailAuth = '/email-auth';
  static const String login = '/login';

  // Brand
  static const String brandShell = '/brand';
  static const String brandHome = '/brand/home';
  static const String factoriesList = '/brand/factories';
  static const String factoryDetails = '/brand/factories/:factoryId';
  static const String createRequest = '/brand/create-request';
  static const String notifPrime = '/brand/notif-prime';
  static const String myRequests = '/brand/requests';
  static const String offers = '/brand/requests/:requestId/offers';
  static const String orderSummary =
      '/brand/requests/:requestId/offers/:offerId/summary';
  static const String waHandoff = '/brand/handoff';

  // Factory
  static const String factoryShell = '/factory';
  static const String factoryProfileSetup = '/factory/setup';
  static const String factoryDashboard = '/factory/dashboard';
  static const String factoryRequests = '/factory/requests';
  static const String requestDetail = '/factory/requests/:requestId';
  static const String sendOffer = '/factory/requests/:requestId/send-offer';
  static const String factoryOffers = '/factory/offers';

  // Profile Settings
  static const String editProfile = '/profile/edit';
  static const String notifications = '/profile/notifications';
  static const String privacySecurity = '/profile/privacy';
  static const String helpSupport = '/profile/help';

  // Keep old names as aliases for backward compatibility
  static const String phoneAuth = emailAuth;
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _brandShellKey = GlobalKey<NavigatorState>(debugLabel: 'brandShell');
final _factoryShellKey = GlobalKey<NavigatorState>(debugLabel: 'factoryShell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;
    final loc = state.matchedLocation;
    final isOnAuthRoute =
        loc == AppRoutes.splash ||
        loc == AppRoutes.onboarding ||
        loc == AppRoutes.roleSelection ||
        loc.startsWith(AppRoutes.emailAuth) ||
        loc.startsWith(AppRoutes.login);

    if (!isLoggedIn && !isOnAuthRoute) return AppRoutes.splash;
    return null;
  },
  routes: [
    // ── Auth Routes ────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.roleSelection,
      builder: (context, state) => const RoleSelectionPage(),
    ),
    GoRoute(
      path: AppRoutes.emailAuth,
      builder: (context, state) {
        final role = state.uri.queryParameters['role'] ?? 'brand';
        return EmailAuthPage(role: role);
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        final role = state.uri.queryParameters['role'] ?? 'brand';
        return LoginPage(role: role);
      },
    ),
    GoRoute(
      path: AppRoutes.factoryProfileSetup,
      builder: (context, state) => const FactoryProfileSetupPage(),
    ),

    // ── Profile Settings Routes ────────────────────
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationsSettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.privacySecurity,
      builder: (context, state) => const PrivacySecurityPage(),
    ),
    GoRoute(
      path: AppRoutes.helpSupport,
      builder: (context, state) => const HelpSupportPage(),
    ),

    // ── Brand Shell (Bottom Nav) ───────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => BrandShellPage(shell: shell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _brandShellKey,
          routes: [
            GoRoute(
              path: AppRoutes.brandHome,
              builder: (context, state) => const BrandHomePage(),
              routes: [],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.factoriesList,
              builder: (context, state) => const FactoriesListPage(),
              routes: [
                GoRoute(
                  path: ':factoryId',
                  builder: (context, state) => FactoryDetailsPage(
                    factoryId: state.pathParameters['factoryId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.myRequests,
              builder: (context, state) => const MyRequestsPage(),
              routes: [
                GoRoute(
                  path: ':requestId/offers',
                  builder: (context, state) =>
                      OffersPage(requestId: state.pathParameters['requestId']!),
                  routes: [
                    GoRoute(
                      path: ':offerId/summary',
                      builder: (context, state) => OrderSummaryPage(
                        requestId: state.pathParameters['requestId']!,
                        offerId: state.pathParameters['offerId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/brand/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),

    // ── Create Request (Modal) ─────────────────────
    GoRoute(
      path: AppRoutes.createRequest,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final factoryId = state.uri.queryParameters['factoryId'];
        return CreateRequestPage(preselectedFactoryId: factoryId);
      },
    ),
    GoRoute(
      path: AppRoutes.notifPrime,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotifPrimePage(),
    ),
    GoRoute(
      path: AppRoutes.waHandoff,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return WaHandoffPage(orderData: extra ?? {});
      },
    ),

    // ── Factory Shell (Bottom Nav) ─────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => FactoryShellPage(shell: shell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _factoryShellKey,
          routes: [
            GoRoute(
              path: AppRoutes.factoryDashboard,
              builder: (context, state) => const FactoryDashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.factoryRequests,
              builder: (context, state) => const FactoryRequestsPage(),
              routes: [
                GoRoute(
                  path: ':requestId',
                  builder: (context, state) => RequestDetailPage(
                    requestId: state.pathParameters['requestId']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'send-offer',
                      builder: (context, state) => SendOfferPage(
                        requestId: state.pathParameters['requestId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.factoryOffers,
              builder: (context, state) => const FactoryOffersPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/factory/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
