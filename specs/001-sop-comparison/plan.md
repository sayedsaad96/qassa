# Implementation Plan: SOP Alignment

**Branch**: `001-sop-comparison` | **Date**: 2026-03-24 | **Spec**: [spec.md](file:///d:/Flutter/qassa/specs/001-sop-comparison/spec.md)
**Input**: Feature specification from `/specs/001-sop-comparison/spec.md`

## Summary

Align the Qassa codebase with the SOP and constitution by fixing
critical architecture gaps (factory module missing data/domain layers),
removing legacy OTP code, adding the missing `quality` field, and
splitting the monolithic `factory_shell_page.dart`. Focus is strictly
on MVP scope — no Phase 2/3 SOP features (chat, payment, shipping).

## Technical Context

**Language/Version**: Dart ≥ 3.11 / Flutter SDK ≥ 3.11
**Primary Dependencies**: flutter_bloc ^9.x, go_router ^17.x, get_it ^9.x, dartz ^0.10, equatable ^2.0
**Storage**: Supabase (PostgreSQL via supabase_flutter ^2.x)
**Testing**: flutter_test (built-in), widget tests, unit tests with mocks
**Target Platform**: Android (primary), iOS, Web
**Project Type**: Mobile app (Flutter)
**Performance Goals**: ≤ 3s cold start, 60fps scrolling, ≤ 25MB APK
**Constraints**: RTL-first UI, offline tolerance, mid-range Android devices
**Scale/Scope**: MVP — 4 feature modules, ~30 screens, 2 user roles

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Gate | Status |
|-----------|------|--------|
| I. Code Quality | All feature modules MUST have data/domain/presentation | ⚠️ FAIL — factory lacks data/ and domain/ |
| I. Code Quality | Models MUST use freezed + json_serializable | ⚠️ FAIL — manual serialization everywhere |
| I. Code Quality | No dead code | ⚠️ FAIL — otp_page.dart, misleading file names |
| II. Testing | Unit tests for all use cases and cubits | ⚠️ FAIL — only stale scaffold test |
| III. UX Consistency | All navigation via go_router | ✅ PASS |
| III. UX Consistency | Theme tokens only (no hard-coded colors) | ✅ PASS |
| IV. Performance | cached_network_image for all network images | ✅ PASS |

**Gate Decision**: FAIL items are resolved by this plan. Proceeding to research.

## Project Structure

### Documentation (this feature)

```text
specs/001-sop-comparison/
├── plan.md              # This file
├── research.md          # Phase 0: architectural decisions
├── data-model.md        # Phase 1: entity/model design
└── checklists/
    └── requirements.md  # Spec quality checklist
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/       # AppColors, AppTextStyles, AppConstants, AppAssets
│   ├── di/injection.dart
│   ├── router/app_router.dart
│   ├── services/user_service.dart
│   ├── theme/app_theme.dart
│   ├── utils/           # app_responsive, performance_utils
│   └── widgets/         # app_widgets, app_asset_widgets
├── features/
│   ├── auth/
│   │   ├── data/datasources/auth_remote_datasource.dart
│   │   ├── data/models/user_model.dart
│   │   ├── data/repositories/auth_repository_impl.dart
│   │   ├── domain/entities/user_entity.dart
│   │   ├── domain/repositories/auth_repository.dart
│   │   ├── domain/usecases/auth_usecases.dart        ← RENAME from send_otp_usecase.dart
│   │   └── presentation/
│   │       ├── cubit/auth_cubit.dart
│   │       └── pages/
│   │           ├── splash_page.dart
│   │           ├── onboarding_page.dart
│   │           ├── email_auth_page.dart               ← RENAME from phone_auth_page.dart
│   │           ├── profile_page.dart
│   │           └── role_selection_page.dart
│   │           [DELETE] otp_page.dart
│   ├── brand/                                         # ✅ complete (data/domain/presentation)
│   ├── factory/
│   │   ├── data/                                      ← NEW
│   │   │   ├── datasources/factory_profile_remote_datasource.dart
│   │   │   ├── models/factory_profile_model.dart
│   │   │   └── repositories/factory_profile_repository_impl.dart
│   │   ├── domain/                                    ← NEW
│   │   │   ├── entities/factory_profile_entity.dart
│   │   │   ├── repositories/factory_profile_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_factory_profile_usecase.dart
│   │   │       ├── create_factory_profile_usecase.dart
│   │   │       └── update_factory_profile_usecase.dart
│   │   └── presentation/
│   │       ├── cubit/factory_profile_cubit.dart        ← NEW
│   │       └── pages/
│   │           ├── factory_shell_page.dart             ← REFACTOR: extract pages
│   │           ├── factory_dashboard_page.dart         ← REWRITE (currently stub)
│   │           ├── factory_requests_page.dart          ← REWRITE (currently stub)
│   │           ├── factory_offers_page.dart            ← REWRITE (currently stub)
│   │           ├── request_detail_page.dart            ← REWRITE (currently stub)
│   │           ├── send_offer_page.dart                ← REWRITE (currently stub)
│   │           └── factory_profile_setup_page.dart     ← NEW (onboarding)
│   └── offers/                                        # ✅ complete (data/domain/presentation)
├── main.dart
test/
├── features/
│   ├── auth/
│   │   ├── domain/usecases/auth_usecases_test.dart    ← NEW
│   │   └── presentation/cubit/auth_cubit_test.dart    ← NEW
│   ├── brand/
│   │   ├── domain/usecases/requests_usecases_test.dart ← NEW
│   │   └── presentation/cubit/requests_cubit_test.dart ← NEW
│   ├── factory/
│   │   ├── domain/usecases/factory_profile_usecases_test.dart ← NEW
│   │   └── presentation/cubit/factory_profile_cubit_test.dart ← NEW
│   └── offers/
│       ├── domain/usecases/offers_usecases_test.dart   ← NEW
│       └── presentation/cubit/offers_cubit_test.dart   ← NEW
└── [DELETE] widget_test.dart                           # stale scaffold test
```

**Structure Decision**: Flutter mobile app with feature-based clean architecture
(data/domain/presentation per feature), as established by the existing brand and
offers modules.

## Proposed Changes

### Phase 1: Legacy Code Removal (Critical — Prerequisite)

#### [DELETE] [otp_page.dart](file:///d:/Flutter/qassa/lib/features/auth/presentation/pages/otp_page.dart)
- Dead code from the old phone-based OTP authentication flow
- No references remain after the email auth migration

#### [MODIFY] [phone_auth_page.dart](file:///d:/Flutter/qassa/lib/features/auth/presentation/pages/phone_auth_page.dart) → RENAME to `email_auth_page.dart`
- File contains `EmailAuthPage` and `LoginPage` classes
- Rename file to match its actual contents
- Update all imports in: `app_router.dart`

#### [MODIFY] [send_otp_usecase.dart](file:///d:/Flutter/qassa/lib/features/auth/domain/usecases/send_otp_usecase.dart) → RENAME to `auth_usecases.dart`
- File contains `SignUpUseCase`, `SignInUseCase`, `GetCurrentUserUseCase`, `SignOutUseCase`
- Rename file to match its actual contents
- Update all imports in: `injection.dart`, `auth_cubit.dart`

#### [DELETE] [widget_test.dart](file:///d:/Flutter/qassa/test/widget_test.dart)
- Stale counter-increment scaffold test — completely unrelated to Qassa

---

### Phase 2: Factory Module Architecture (Critical — MVP Enabler)

#### [NEW] [factory_profile_entity.dart](file:///d:/Flutter/qassa/lib/features/factory/domain/entities/factory_profile_entity.dart)
- Reuse the existing `FactoryEntity` from brand module as the base
- Factory profile entity with all SOP fields: name, city, specialties, MOQ, lead_time_days, cover_image_url, portfolio_images

#### [NEW] [factory_profile_repository.dart](file:///d:/Flutter/qassa/lib/features/factory/domain/repositories/factory_profile_repository.dart)
- Abstract repository with: `getProfile(ownerId)`, `createProfile(entity)`, `updateProfile(entity)`

#### [NEW] [get_factory_profile_usecase.dart](file:///d:/Flutter/qassa/lib/features/factory/domain/usecases/get_factory_profile_usecase.dart)
#### [NEW] [create_factory_profile_usecase.dart](file:///d:/Flutter/qassa/lib/features/factory/domain/usecases/create_factory_profile_usecase.dart)
#### [NEW] [update_factory_profile_usecase.dart](file:///d:/Flutter/qassa/lib/features/factory/domain/usecases/update_factory_profile_usecase.dart)

#### [NEW] [factory_profile_model.dart](file:///d:/Flutter/qassa/lib/features/factory/data/models/factory_profile_model.dart)
- Data model with `fromJson`/`toJson` mapping to Supabase `factories` table

#### [NEW] [factory_profile_remote_datasource.dart](file:///d:/Flutter/qassa/lib/features/factory/data/datasources/factory_profile_remote_datasource.dart)
- CRUD operations against `public.factories` table via SupabaseClient

#### [NEW] [factory_profile_repository_impl.dart](file:///d:/Flutter/qassa/lib/features/factory/data/repositories/factory_profile_repository_impl.dart)
- Implements abstract repository, maps data models to entities

#### [NEW] [factory_profile_cubit.dart](file:///d:/Flutter/qassa/lib/features/factory/presentation/cubit/factory_profile_cubit.dart)
- States: Initial, Loading, Loaded, Created, Updated, Error
- Actions: loadProfile(), createProfile(), updateProfile()

---

### Phase 3: Factory Pages Extraction (Critical — Code Quality)

#### [MODIFY] [factory_shell_page.dart](file:///d:/Flutter/qassa/lib/features/factory/presentation/pages/factory_shell_page.dart)
- Currently 1116 lines containing ALL factory pages
- Extract into separate files: `FactoryShellPage` + `_FactoryNavItem` stay
- Move `FactoryDashboardPage` → `factory_dashboard_page.dart`
- Move `FactoryRequestsPage` → `factory_requests_page.dart`
- Move `RequestDetailPage` → `request_detail_page.dart`
- Move `SendOfferPage` → `send_offer_page.dart`
- Move `FactoryOffersPage` → `factory_offers_page.dart`
- Each stub file gets the real extracted class

#### [NEW] [factory_profile_setup_page.dart](file:///d:/Flutter/qassa/lib/features/factory/presentation/pages/factory_profile_setup_page.dart)
- Factory onboarding profile creation page
- Fields per SOP: Name, Location, Product Types, MOQ, Price Range, Images, Description

#### [MODIFY] [app_router.dart](file:///d:/Flutter/qassa/lib/core/router/app_router.dart)
- Add factory profile setup route between role selection and factory dashboard
- Remove dead `otp` route reference

#### [MODIFY] [injection.dart](file:///d:/Flutter/qassa/lib/core/di/injection.dart)
- Register all new factory module dependencies
- Update import paths for renamed files

---

### Phase 4: Quality Field Addition (Medium — SOP Alignment)

#### [MODIFY] Supabase schema (manual migration)
- Add `quality TEXT CHECK (quality IN ('low', 'medium', 'high'))` to `requests` table
- Default: `'medium'`

#### [MODIFY] [entities.dart](file:///d:/Flutter/qassa/lib/features/brand/domain/entities/entities.dart)
- Add `quality` field (enum: low, medium, high) to `RequestEntity`

#### [MODIFY] [models.dart](file:///d:/Flutter/qassa/lib/features/brand/data/models/models.dart)
- Add `quality` field to `RequestModel` with `fromJson`/`toJson` mapping

#### [MODIFY] [create_request_page.dart](file:///d:/Flutter/qassa/lib/features/brand/presentation/pages/create_request_page.dart)
- Add quality level selector (Low/Medium/High) to the create request form

#### [MODIFY] [requests_cubit.dart](file:///d:/Flutter/qassa/lib/features/brand/presentation/cubit/requests_cubit.dart)
- Pass `quality` parameter through to `createRequest()`

---

### Phase 5: Unit Tests (Critical — Constitution Compliance)

#### [NEW] `test/features/auth/domain/usecases/auth_usecases_test.dart`
- Test SignUpUseCase, SignInUseCase, SignOutUseCase with mocked AuthRepository
- Verify Either left/right responses

#### [NEW] `test/features/auth/presentation/cubit/auth_cubit_test.dart`
- Test state transitions: Initial → Loading → Authenticated/Error
- Test signUp, signIn, signOut methods

#### [NEW] `test/features/brand/presentation/cubit/requests_cubit_test.dart`
- Test loadMyRequests, loadAllRequests, createRequest, switchTab
- Test error states and filtering

#### [NEW] `test/features/offers/presentation/cubit/offers_cubit_test.dart`
- Test loadOffers, sendOffer, acceptOffer
- Test error states

#### [NEW] `test/features/factory/presentation/cubit/factory_profile_cubit_test.dart`
- Test loadProfile, createProfile, updateProfile
- Test error states

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|--------------------------------------|
| Factory reuses brand's `FactoryEntity` | Same Supabase table schema, avoids duplication | Factory-specific entity would duplicate fields with no benefit |

## Verification Plan

### Automated Tests

1. **Static analysis**: `flutter analyze` — MUST produce zero errors and zero warnings
2. **Unit tests**: `flutter test test/features/` — MUST pass all new tests
3. **Build verification**: `flutter build apk --debug` — MUST compile successfully

### Manual Verification

1. **Brand flow** (test on device/emulator):
   - Open app → Onboarding → Select "Brand" → Email signup
   - Create request (verify quality field appears) → Browse factories → View details
   - Expected: All screens render correctly, no dead-end pages

2. **Factory flow** (test on device/emulator):
   - Open app → Onboarding → Select "Factory" → Email signup
   - Verify factory profile setup page appears after role selection
   - Fill profile → navigate to dashboard → browse requests → send offer
   - Expected: Full factory onboarding flow works end-to-end

3. **Legacy code removal**:
   - Grep the codebase for "otp" (case-insensitive) — MUST return zero matches outside of git history
   - Grep for "phone_auth" — MUST return zero matches
   - Expected: No stale references remain
