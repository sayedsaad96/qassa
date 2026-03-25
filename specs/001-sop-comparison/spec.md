# Feature Specification: Qassa App SOP Comparison

**Feature Branch**: `001-sop-comparison`
**Created**: 2026-03-24
**Status**: Draft
**Input**: Compare current project implementation against SOP, detect gaps, generate prioritized update plan.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - SOP Gap Detection & Alignment (Priority: P1) 🎯 MVP

A developer or project maintainer needs to understand where the current
Qassa codebase deviates from the SOP and what must be fixed to reach
MVP readiness.

**Why this priority**: Without closing these gaps, the app cannot
launch as described in the SOP. This is the foundational deliverable.

**Independent Test**: Verify by cross-referencing every SOP section
against the codebase and confirming all listed gaps are addressed.

**Acceptance Scenarios**:

1. **Given** the SOP specifies Email & Password authentication,
   **When** inspecting the auth module,
   **Then** all OTP/phone references are removed and email auth is
   the sole mechanism.
2. **Given** the SOP specifies factory profile management,
   **When** inspecting the factory module,
   **Then** `data/` and `domain/` layers exist with proper clean
   architecture separation.
3. **Given** the SOP specifies both Brand and Factory user flows,
   **When** all flows are tested end-to-end,
   **Then** each flow is functional with no dead-end screens.

---

### User Story 2 - Codebase Hygiene & Constitution Compliance (Priority: P2)

A developer needs assurance that the codebase follows the project
constitution and established patterns.

**Why this priority**: Technical debt impedes future feature work and
violates the constitution's Code Quality principle.

**Independent Test**: Run `flutter analyze` with zero warnings and
verify architecture layer separation in all feature modules.

**Acceptance Scenarios**:

1. **Given** the constitution mandates freezed + json_serializable,
   **When** inspecting all entity/model classes,
   **Then** all use freezed annotations (no manual fromJson/toJson).
2. **Given** the constitution mandates test coverage,
   **When** running `flutter test`,
   **Then** tests exist for all use cases, cubits, and critical pages.

---

### User Story 3 - Data Model Alignment (Priority: P3)

The Supabase schema and Dart models must mirror the SOP data model.

**Why this priority**: Data model discrepancies cause runtime errors
and prevent correct feature behavior.

**Independent Test**: Compare each SOP table against the Supabase
schema and Dart entities field-by-field.

**Acceptance Scenarios**:

1. **Given** the SOP defines a `quality` field on Requests (Low/Medium/High),
   **When** inspecting the schema and entities,
   **Then** the field exists and is usable in the create-request flow.
2. **Given** the SOP defines a `budget` (Decimal range) on Requests,
   **When** inspecting the implementation,
   **Then** the field maps correctly (currently `target_price_per_piece`
   serves this purpose — validate alignment).

---

### Edge Cases

- What happens when the SOP describes a feature that conflicts with an
  existing implementation that works correctly?
  → Prioritize the working implementation if it achieves the same user
  outcome; flag the SOP discrepancy for documentation update.
- What happens when a SOP field exists in the schema but not in the
  Dart model (or vice versa)?
  → Flag as a critical gap; the model must be synced.

## Requirements *(mandatory)*

### Functional Requirements

#### Auth Module

- **FR-001**: System MUST use Email & Password as the sole
  authentication mechanism — no OTP or phone-based flows.
- **FR-002**: The file `otp_page.dart` MUST be deleted as dead code.
- **FR-003**: The file `phone_auth_page.dart` MUST be renamed to
  `email_auth_page.dart` for clarity.
- **FR-004**: The `send_otp_usecase.dart` file name MUST be updated
  to reflect its actual contents (SignUp/SignIn/SignOut use cases).

#### Brand Module

- **FR-005**: Brand profile creation screen MUST exist and allow
  setting: name, contact info.
- **FR-006**: Create Request flow MUST support: Product Type, Quantity,
  Quality Level, Budget Range (required) and Upload Design, Notes
  (optional) per SOP §3.1.
- **FR-007**: Browse Factories MUST support filters: Location, MOQ,
  Product Type, Rating per SOP §3.1.
- **FR-008**: RFQ sending MUST be available from factory browsing flow.
- **FR-009**: Offers comparison MUST allow side-by-side evaluation.

#### Factory Module

- **FR-010**: Factory module MUST have `data/`, `domain/`, and
  `presentation/` layers (currently only `presentation/` exists).
- **FR-011**: Factory Profile setup MUST support: Name, Location,
  Product Types, MOQ, Price Range, Images, Description per SOP §3.2.
- **FR-012**: Factory MUST be able to manage requests with statuses:
  Pending / Accepted / Rejected per SOP §3.2.
- **FR-013**: Factory MUST have a dedicated profile creation/edit
  screen in the onboarding flow.

#### Data Model

- **FR-014**: Request entity MUST include a `quality` field
  (Low/Medium/High) per SOP §5.3.
- **FR-015**: Request entity MUST include a `budget` field or the
  existing `target_price_per_piece` MUST be documented as the SOP
  equivalent.
- **FR-016**: All entities MUST use `freezed` + `json_serializable`
  per constitution Principle I.

#### Code Quality & Testing

- **FR-017**: All models MUST use freezed for immutability.
- **FR-018**: Unit tests MUST exist for all use cases and cubits.
- **FR-019**: Widget tests MUST exist for critical pages (auth flow,
  create request, offers).
- **FR-020**: `flutter analyze` MUST produce zero warnings.

### Key Entities

- **User**: id, email, name, role (brand/factory), brand_name, phone
- **Factory**: id, owner_id, name, city, specialties, min_quantity,
  lead_time_days, rating, review_count, cover_image_url,
  portfolio_images, is_fast_responder
- **Request**: id, brand_id, brand_name, product_type, quantity,
  **quality**, budget/target_price_per_piece, material, notes,
  reference_image_url, status, request_number
- **Offer**: id, request_id, factory_id, factory_name, price_per_piece,
  lead_time_days, notes, status

## Comparison Report

### ✅ Implemented & Aligned with SOP

| SOP Requirement | Implementation | Status |
|----------------|---------------|--------|
| Email & Password Auth | `auth_remote_datasource.dart` uses `signUp`/`signIn` with email | ✅ Working |
| Role Selection (Brand/Factory) | `role_selection_page.dart` exists | ✅ Working |
| Create Manufacturing Request | `create_request_page.dart` + full data/domain/presentation layers | ✅ Working |
| Browse Factories | `factories_list_page.dart` + `FactoriesListPage` | ✅ Working |
| View Factory Details | `factory_details_page.dart` | ✅ Working |
| Receive Offers (Brand) | `offers_page.dart` + `OffersCubit` | ✅ Working |
| Receive Requests (Factory) | `factory_requests_page.dart` | ✅ Working |
| Send Offers (Factory) | `send_offer_page.dart` | ✅ Working |
| Manage Requests (Factory) | `request_detail_page.dart` | ✅ Working |
| Supabase Schema | 4 tables (users, factories, requests, offers) with RLS | ✅ Complete |
| Storage Buckets | `request-images` and `factory-images` configured | ✅ Complete |
| go_router Navigation | All routes in `app_router.dart` | ✅ Working |
| get_it DI | `injection.dart` with full dependency graph | ✅ Working |
| Clean Architecture (brand) | data/domain/presentation layers | ✅ Complete |
| Clean Architecture (offers) | data/domain/presentation layers | ✅ Complete |
| RTL Support | `Directionality(textDirection: TextDirection.rtl)` in main | ✅ Working |

### ❌ Missing or Misaligned

| # | SOP Requirement | Current State | Severity | Fix Required |
|---|----------------|--------------|----------|-------------|
| 1 | Factory `data/` + `domain/` layers | Only `presentation/` exists — no repository, datasource, or use cases | 🔴 Critical | Create full clean architecture layers |
| 2 | Factory Profile Setup screen | No profile creation/edit page for factory onboarding | 🔴 Critical | Build factory profile setup page |
| 3 | `quality` field on Requests | Missing from schema, model, and entity | 🟡 Medium | Add enum field (Low/Medium/High) |
| 4 | `budget` field naming | SOP says "budget", code uses `target_price_per_piece` | 🟢 Low | Document as equivalent or add alias |
| 5 | Dead code: `otp_page.dart` | File exists but unused since email auth migration | 🟡 Medium | Delete file |
| 6 | Filename: `phone_auth_page.dart` | Contains `EmailAuthPage` + `LoginPage` — misleading name | 🟡 Medium | Rename to `email_auth_page.dart` |
| 7 | Filename: `send_otp_usecase.dart` | Contains `SignUpUseCase`, `SignInUseCase`, `SignOutUseCase` | 🟡 Medium | Rename to `auth_usecases.dart` |
| 8 | Models not using `freezed` | Manual constructors, `fromJson`, `toJson` everywhere | 🟡 Medium | Migrate to `freezed` + `json_serializable` |
| 9 | No unit tests | Only default `widget_test.dart` exists | 🔴 Critical | Write tests for all use cases & cubits |
| 10 | No widget tests | Zero widget tests for any page | 🟡 Medium | Add tests for critical flows |
| 11 | Filter factories by Location/MOQ/Rating | Browsing exists but filters not confirmed | 🟡 Medium | Verify filters or add them |
| 12 | Brand Profile creation screen | Profile page exists but creation flow during onboarding unclear | 🟡 Medium | Verify or add brand profile setup |
| 13 | Offer comparison (side-by-side) | Offers list exists, but comparison UX not confirmed | 🟢 Low | Verify or enhance comparison UI |
| 14 | `design_url` on Request (SOP §5.3) | Code uses `reference_image_url` — functionally same | 🟢 Low | Document as equivalent |

### ⚠️ Constitution Violations Detected

| # | Constitution Principle | Violation | Severity |
|---|----------------------|-----------|----------|
| 1 | I. Code Quality | Factory module missing `data/` and `domain/` layers | 🔴 Critical |
| 2 | I. Code Quality | Models use manual serialization, not `freezed` | 🟡 Medium |
| 3 | I. Code Quality | File names don't match contents (OTP → email) | 🟡 Medium |
| 4 | II. Testing Standards | Only 1 default test exists; zero coverage | 🔴 Critical |
| 5 | I. Code Quality | Dead code (`otp_page.dart`) not removed | 🟡 Medium |

## Update Plan (Prioritized)

### Phase 1: Critical MVP Fixes 🔴

| Task | Priority | Est. Effort | Description |
|------|----------|------------|-------------|
| T-001 | P1 | Large | Build Factory `data/` layer: `factory_remote_datasource.dart`, `factory_profile_repository_impl.dart` |
| T-002 | P1 | Large | Build Factory `domain/` layer: `factory_profile_entity.dart`, `factory_profile_repository.dart`, use cases |
| T-003 | P1 | Large | Build Factory Profile Setup page with all SOP fields |
| T-004 | P1 | Medium | Wire factory profile creation into onboarding flow (after role selection) |
| T-005 | P1 | Large | Write unit tests for all existing use cases (auth, brand, offers) |

### Phase 2: Code Hygiene & Alignment 🟡

| Task | Priority | Est. Effort | Description |
|------|----------|------------|-------------|
| T-006 | P2 | Small | Delete `otp_page.dart` (dead code) |
| T-007 | P2 | Small | Rename `phone_auth_page.dart` → `email_auth_page.dart`, update all imports |
| T-008 | P2 | Small | Rename `send_otp_usecase.dart` → `auth_usecases.dart`, update all imports |
| T-009 | P2 | Medium | Add `quality` enum field to requests schema, model, entity, and form |
| T-010 | P2 | Medium | Add/verify factory browsing filters (location, MOQ, product type, rating) |
| T-011 | P2 | Medium | Write widget tests for auth flow, create-request, and offers pages |
| T-012 | P2 | Medium | Enhance offer comparison UI for side-by-side evaluation |

### Phase 3: Constitution Compliance (Freezed) 🔴

| Task | Priority | Est. Effort | Description |
|------|----------|------------|-------------|
| T-013 | P2 | Large | Migrate all models/entities to `freezed` + `json_serializable` |

### Phase 4: Polish & Documentation 🟢

| Task | Priority | Est. Effort | Description |
|------|----------|------------|-------------|
| T-014 | P3 | Small | Document `target_price_per_piece` ↔ SOP `budget` mapping |
| T-015 | P3 | Small | Document `reference_image_url` ↔ SOP `design_url` mapping |
| T-016 | P3 | Small | Verify brand profile creation flow is complete in onboarding |
| T-017 | P3 | Small | Run `flutter analyze` and fix all warnings to zero |

## Validation Checklist

### Pre-Implementation Validation

- [ ] All Phase 1 tasks preserve existing working functionality
- [ ] Factory module follows same architecture pattern as brand module
- [ ] New factory profile fields match Supabase `factories` table schema
- [ ] Test mocks/fakes are used for all Supabase interactions

### Post-Implementation Validation

- [ ] `flutter analyze` — zero warnings
- [ ] `flutter test` — zero failures
- [ ] Brand flow: signup → create request → browse factories → send RFQ → receive offers
- [ ] Factory flow: signup → setup profile → receive requests → send offers → manage requests
- [ ] No dead code references (OTP, phone auth)
- [ ] All file names accurately reflect their contents
- [ ] Factory module has `data/`, `domain/`, `presentation/` layers
- [ ] All entity/model classes use `freezed`
- [ ] Factory browsing supports location, MOQ, product type, and rating filters
- [ ] Request creation includes quality level field

### Breaking Change Assessment

- [ ] File renames (T-006, T-007, T-008): Low risk — update imports via IDE refactor
- [ ] `freezed` migration (T-013): Medium risk — verify all `fromJson`/`toJson` calls still work
- [ ] Schema change for `quality` field (T-009): Low risk — nullable column addition, backward compatible
- [ ] Factory module restructure (T-001–T-004): Medium risk — new code, but non-breaking to existing features

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All SOP MVP features (§4) are functional and testable end-to-end
- **SC-002**: Zero `flutter analyze` warnings across the entire codebase
- **SC-003**: Unit test coverage exists for 100% of use cases and cubits
- **SC-004**: Both user journeys (Brand and Factory) are completable from signup to core action within 5 screens
- **SC-005**: All feature modules follow clean architecture with `data/`, `domain/`, `presentation/` separation
- **SC-006**: Zero dead code files remain in the repository
