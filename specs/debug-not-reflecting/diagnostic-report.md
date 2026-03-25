# Diagnostic Report: Application Not Reflecting Changes

**Generated**: 2026-03-25
**Project**: Qassa (d:\Flutter\qassa)
**Status**: Diagnostic Complete — Issues Found

---

## Executive Summary

The static analyzer reports **zero compile-time errors**, so the code builds cleanly. However, several architectural and wiring issues prevent recently implemented features from being visible or functional at runtime. The root causes fall into three categories:

1. **🔴 Critical: Cubit instance fragmentation** — `registerFactory` creates new cubit instances on every `sl<CubitType>()` call, so `BlocProvider.value` and `initState` receive different instances.
2. **🟡 Medium: Missing BlocProvider on FactoryProfileSetupPage** — the page uses `context.read<FactoryProfileCubit>()` but no ancestor provides it.
3. **🟢 Low: Stub pages masking real pages** — `factory_details_page.dart`, `order_summary_page.dart`, and `wa_handoff_page.dart` are export-only barrel files. This works but is fragile.

---

## Issue #1: Cubit Instance Fragmentation (🔴 CRITICAL — ROOT CAUSE)

### Problem

In `lib/core/di/injection.dart`, three cubits are registered with `sl.registerFactory(...)`:

| Line | Registration | Type |
|------|-------------|------|
| 75–78 | `sl.registerFactory(() => FactoriesCubit(...))` | Factory |
| 90–96 | `sl.registerFactory(() => FactoryProfileCubit(...))` | Factory |
| 108–114 | `sl.registerFactory(() => RequestsCubit(...))` | Factory |
| 124–131 | `sl.registerFactory(() => OffersCubit(...))` | Factory |

**`registerFactory` creates a NEW instance every time `sl<CubitType>()` is called.**

### Impact

Every page that does this pattern:
```dart
@override
void initState() {
  super.initState();
  unawaited(sl<RequestsCubit>().loadMyRequests()); // instance A — loads data
}

@override
Widget build(BuildContext context) {
  return BlocProvider.value(
    value: sl<RequestsCubit>(),  // instance B — NEW, different, still Initial!
    child: BlocBuilder<RequestsCubit, RequestsState>(
      builder: (context, state) {
        // state is always RequestsInitial, never gets the loaded data
      },
    ),
  );
}
```

**Data is loaded into instance A, but the UI listens to instance B.** The UI never sees the loaded data.

### Affected Pages (all of them)

| Page | Cubit | Lines with `sl<>()` calls |
|------|-------|--------------------------|
| `brand_home_page.dart` | `FactoriesCubit` | L31 (initState), L49 (BlocProvider), L57 (refresh) |
| `factories_list_page.dart` | `FactoriesCubit` | L34, L40, L74, L92, L104, L114 |
| `factories_list_page.dart` (details) | `FactoriesCubit` | L272, L278, L291 |
| `my_requests_page.dart` | `RequestsCubit` | L30, L36, L82, L96, L121 |
| `create_request_page.dart` | `RequestsCubit` | L54, L419 |
| `offers_page.dart` | `OffersCubit` | L33, L39, L55, L68 |
| `offers_page.dart` (OrderSummary) | `OffersCubit` | L530, L764 |
| `factory_requests_page.dart` | `RequestsCubit` | L34, L40, L68, L86, L99 |
| `factory_offers_page.dart` | `OffersCubit` | L30, L36, L45 |
| `send_offer_page.dart` | `OffersCubit` | L40, L182 |

### Fix Required

**Option A (Recommended): Change cubits to `registerLazySingleton`**

```dart
// injection.dart — change all 4 cubit registrations
sl.registerLazySingleton(
  () => FactoriesCubit(getFactoriesUseCase: sl(), getFactoryByIdUseCase: sl()),
);
sl.registerLazySingleton(
  () => FactoryProfileCubit(
    getFactoryProfileUseCase: sl(),
    createFactoryProfileUseCase: sl(),
    updateFactoryProfileUseCase: sl(),
  ),
);
sl.registerLazySingleton(
  () => RequestsCubit(
    createRequestUseCase: sl(),
    getRequestsUseCase: sl(),
    userService: sl(),
  ),
);
sl.registerLazySingleton(
  () => OffersCubit(
    getOffersUseCase: sl(),
    sendOfferUseCase: sl(),
    acceptOfferUseCase: sl(),
    userService: sl(),
  ),
);
```

This ensures the same cubit instance is used everywhere, matching how `BlocProvider.value` + `sl<>()` is used across all pages.

**Option B (Better architecture, more work): Use `BlocProvider` (not `.value`) in each page and stop depending on GetIt for cubits**

```dart
// In each page:
@override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<RequestsCubit>()..loadMyRequests(),
    child: BlocBuilder<RequestsCubit, RequestsState>(...),
  );
}
```

This is the idiomatic BLoC approach and avoids global state, but requires refactoring all pages.

---

## Issue #2: Missing BlocProvider on FactoryProfileSetupPage (🔴 CRITICAL)

### Problem

`factory_profile_setup_page.dart` uses:
- `context.read<FactoryProfileCubit>()` (line 75)
- `BlocConsumer<FactoryProfileCubit, FactoryProfileState>` (line 86)

But the route in `app_router.dart` (line 111–113) does NOT provide a `BlocProvider`:
```dart
GoRoute(
  path: AppRoutes.factoryProfileSetup,
  builder: (context, state) => const FactoryProfileSetupPage(), // ❌ No BlocProvider!
),
```

### Impact

Navigating to `/factory/setup` will **crash at runtime** with:
```
ProviderNotFoundException: No FactoryProfileCubit found in context
```

### Fix Required

Wrap the page in a `BlocProvider`:

```dart
GoRoute(
  path: AppRoutes.factoryProfileSetup,
  builder: (context, state) => BlocProvider(
    create: (_) => sl<FactoryProfileCubit>(),
    child: const FactoryProfileSetupPage(),
  ),
),
```

Or add a `BlocProvider.value` inside `FactoryProfileSetupPage.build()`:

```dart
@override
Widget build(BuildContext context) {
  return BlocProvider.value(
    value: sl<FactoryProfileCubit>(),
    child: Scaffold(
      // ...existing code...
      body: BlocConsumer<FactoryProfileCubit, FactoryProfileState>(
        // ...
      ),
    ),
  );
}
```

---

## Issue #3: Barrel File Pattern — Not a Bug but Fragile (🟢 LOW)

### Observation

Three page files are barrel exports instead of containing actual widgets:

| File | Content | Actual Widget Location |
|------|---------|----------------------|
| `factory_details_page.dart` (35 bytes) | `export 'factories_list_page.dart';` | `factories_list_page.dart:260` |
| `order_summary_page.dart` (27 bytes) | `export 'offers_page.dart';` | `offers_page.dart:511` |
| `wa_handoff_page.dart` (32 bytes) | `export 'notif_prime_page.dart';` | `notif_prime_page.dart:117` |

This **works** because the router imports these files and gets the widgets via the export chain. However:
- It violates the pattern of one-widget-per-file
- It makes navigation and debugging confusing
- IDE "Go to Definition" goes to the barrel file, not the widget

### Recommendation (non-blocking)

Either:
- Move each widget class to its own file, or
- Keep as-is and document the pattern for the team

---

## Issue #4: AuthCubit is Registered as Singleton (✅ OK)

The `AuthCubit` is registered with `registerLazySingleton` (line 58–64), which is correct since it's used across `EmailAuthPage`, `LoginPage`, and `ProfilePage` with `BlocProvider.value(value: sl<AuthCubit>())`.

---

## Build/Runtime Checklist

| Check | Status | Notes |
|-------|--------|-------|
| `flutter analyze` | ✅ Zero errors | Clean compilation |
| Routing complete | ✅ All routes wired | 22 pages connected to router |
| DI graph complete | ✅ All deps registered | auth, brand, factory, offers |
| Cubits provided to UI | ❌ **BROKEN** | `registerFactory` + `BlocProvider.value` = instance mismatch |
| FactoryProfileSetup provided | ❌ **BROKEN** | No BlocProvider in ancestor |
| Hot reload sufficient | ❌ **No** | DI registration changes require full restart |

---

## Required Actions (Ordered)

### 1. Fix cubit registrations in `injection.dart` (fixes all pages)

Change all 4 `registerFactory` → `registerLazySingleton` for cubits.

### 2. Wrap `FactoryProfileSetupPage` with `BlocProvider`

Either in the router or inside the page itself.

### 3. Full restart required (not hot reload)

Since DI container configuration changes (`registerFactory` → `registerLazySingleton`), a **full restart** (`flutter run` restart, not hot reload) is needed. GetIt initializes once during `configureDependencies()` and hot reload doesn't re-run `main()`.

---

## Verification After Fixes

1. Navigate to Brand Home → factories should load and display
2. Navigate to My Requests → requests should load
3. Navigate to a request's offers → offers should display
4. Navigate to Factory Profile Setup → page should work without crash
5. Create a request → should navigate back with success
6. Pull-to-refresh → should reload with updated data
7. Tab switching on My Requests → should filter correctly
