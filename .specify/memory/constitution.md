<!--
  Sync Impact Report
  ==================
  Version change: 0.0.0 → 1.0.0 (MAJOR — initial ratification)
  Modified principles: N/A (first version)
  Added sections:
    - Core Principles (4): Code Quality, Testing Standards,
      UX Consistency, Performance Requirements
    - Technology Constraints
    - Development Workflow
    - Governance
  Removed sections: None
  Templates requiring updates:
    - plan-template.md   ✅ compatible (Constitution Check section present)
    - spec-template.md   ✅ compatible (success criteria align with perf principle)
    - tasks-template.md  ✅ compatible (test phases align with testing principle)
  Follow-up TODOs: None
-->

# Qassa Constitution

## Core Principles

### I. Code Quality (NON-NEGOTIABLE)

All Dart/Flutter code in Qassa MUST follow clean architecture with
strict separation into three layers:

- **Presentation** (`features/*/presentation/`): Widgets, BLoC/Cubit,
  pages. MUST NOT import data-layer classes directly.
- **Domain** (`features/*/domain/`): Entities, repositories (abstract),
  use-cases. MUST contain zero Flutter/framework imports.
- **Data** (`features/*/data/`): Repository implementations, data
  sources, DTOs. MUST be the only layer that touches Supabase, HTTP,
  or local storage.

Additional rules:

- Every feature MUST live under `lib/features/<feature_name>/` with
  its own `data/`, `domain/`, and `presentation/` subdirectories.
- Shared code MUST live in `lib/core/` (theme, router, DI, constants,
  utils, widgets).
- `get_it` MUST be the sole dependency injection mechanism; service
  locator calls MUST be limited to DI setup and top-level widget
  constructors.
- All models MUST use `freezed` + `json_serializable` for
  immutability and serialization. Manual `toJson`/`fromJson` is
  prohibited for domain entities.
- BLoC/Cubit MUST be the sole state management solution. `setState`
  is only permitted inside leaf widgets with purely local, ephemeral
  UI state (e.g., animation controllers).
- Lint rules from `flutter_lints` MUST pass with zero warnings before
  any code is considered complete. Ignoring a lint MUST include a
  justification comment.
- Functions exceeding 40 lines or classes exceeding 300 lines MUST be
  refactored unless an explicit exception is documented in the PR.

### II. Testing Standards

All new features and bug fixes MUST include corresponding tests.
Testing tiers:

1. **Unit Tests** — MUST cover every use-case, repository
   implementation, and BLoC/Cubit. Target ≥ 80 % line coverage for
   business logic in `domain/` and `data/` layers.
2. **Widget Tests** — MUST cover critical user-facing screens (auth
   flow, RFQ creation, offer management). Every page under
   `presentation/pages/` MUST have at least one golden-path widget
   test.
3. **Integration Tests** — MUST exist for the two primary user
   journeys: Brand flow (signup → create request → send RFQ → receive
   offer) and Factory flow (signup → setup profile → receive request →
   send offer).

Rules:

- Tests MUST NOT depend on network calls; use mocks/fakes for
  Supabase and Dio interactions.
- Test file naming convention: `<source_file>_test.dart`, located in
  the mirrored path under `test/`.
- `flutter test` MUST pass with zero failures on every commit. Broken
  tests block all other work.
- Flaky tests MUST be fixed or quarantined within 24 hours of
  detection with a tracking TODO.

### III. UX Consistency

Qassa targets Arabic-speaking brand owners and factory operators.
The UI MUST be coherent, accessible, and culturally appropriate.

- **RTL First**: All layouts MUST render correctly in RTL. Manual
  `Directionality` overrides are prohibited; rely on `MaterialApp`
  locale configuration.
- **Typography**: The Cairo font family MUST be used for headings and
  the Tajawal family for body text. No system-default fonts are
  permitted in user-facing screens.
- **Theme Tokens**: All colours, spacing, and elevation values MUST
  come from `lib/core/theme/`. Hard-coded colour literals in widget
  files are prohibited.
- **Loading States**: Every screen that fetches data MUST show a
  shimmer skeleton (using the `shimmer` package) during loading and a
  user-friendly error state with a retry action on failure.
- **Forms**: Forms MUST validate inline on field blur AND on submit.
  MUST use bilingual labels (Arabic primary, English secondary) where
  space permits. Minimum touch target size: 48 × 48 dp.
- **Navigation**: `go_router` MUST be the sole navigation mechanism.
  No raw `Navigator.push` calls. All routes MUST be defined in
  `lib/core/router/app_router.dart`.
- **Accessibility**: All interactive elements MUST have semantic
  labels. Contrast ratios MUST meet WCAG 2.1 AA (≥ 4.5:1 for normal
  text, ≥ 3:1 for large text).

### IV. Performance Requirements

Qassa MUST feel responsive on mid-range Android devices
(e.g., 2 GB RAM, Snapdragon 4-series).

- **Startup**: Cold-start to first interactive frame MUST be ≤ 3 s on
  a mid-range device over a 4G connection.
- **Frame Rate**: Scroll and animation jank MUST stay below 1 %
  dropped frames in profile-mode benchmarks. Target 60 fps on all
  list views.
- **Network**: API calls MUST complete display-ready data within 2 s
  (p95) under 4G conditions. All list endpoints MUST implement
  pagination (max 20 items per page).
- **Image Handling**: All network images MUST use
  `cached_network_image` with placeholder and error widgets. Image
  uploads MUST be compressed to ≤ 500 KB before sending to Supabase
  Storage.
- **APK Size**: Release APK (arm64) MUST remain ≤ 25 MB. Any
  dependency addition that increases APK size by > 500 KB MUST be
  justified.
- **Memory**: The app MUST NOT exceed 150 MB resident memory during
  normal operation. BLoC streams MUST be disposed in `close()` to
  prevent leaks.
- **Offline Tolerance**: The app MUST gracefully handle lost
  connectivity—show cached data where available and surface a clear
  "no connection" indicator. Crash-on-disconnect is never acceptable.

## Technology Constraints

| Layer | Technology | Version Constraint |
|-------|-----------|-------------------|
| Framework | Flutter | SDK ≥ 3.11 |
| Language | Dart | SDK ≥ 3.11 |
| State | flutter_bloc | ^9.x |
| Navigation | go_router | ^17.x |
| Backend | Supabase (supabase_flutter) | ^2.x |
| HTTP | Dio | ^5.x |
| DI | get_it | ^9.x |
| Models | freezed + json_serializable | ^3.x / ^6.x |
| Linting | flutter_lints | ^6.x |

New dependencies MUST be justified against the following criteria:
actively maintained (commit within last 6 months), >100 pub.dev
likes, compatible licence (MIT/BSD/Apache-2.0), and no duplication
of functionality already present in the stack.

## Development Workflow

1. **Branch per feature/fix**: Branch naming MUST follow
   `<type>/<short-description>` (e.g., `feat/rfq-filters`,
   `fix/offer-status`).
2. **Commit messages**: MUST use Conventional Commits format
   (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`).
3. **Pre-commit gate**: `flutter analyze` and `flutter test` MUST
   pass locally before pushing.
4. **Code review**: Every change MUST be reviewed against this
   constitution's principles before merge. Reviewers MUST verify:
   - Layer separation (Principle I)
   - Test coverage (Principle II)
   - UX consistency (Principle III)
   - No performance regressions (Principle IV)
5. **No TODO debt**: TODOs MUST include a tracking reference
   (issue number or date). TODOs older than 30 days MUST be resolved
   or promoted to a tracked issue.

## Governance

This constitution is the supreme reference for all development
decisions in the Qassa project. In case of conflict between this
document and any other guideline, SOP, or ad-hoc decision, this
constitution prevails.

- **Amendments**: Any change to this constitution MUST be documented
  with a version bump, rationale, and updated Sync Impact Report.
  Changes to principles require MAJOR version increment; new sections
  require MINOR; clarifications require PATCH.
- **Compliance Review**: At the start of every new feature, the
  implementation plan MUST include a "Constitution Check" section
  verifying alignment with all four principles.
- **Enforcement**: `flutter analyze` (zero warnings) and
  `flutter test` (zero failures) are automated gates. UX and
  performance principles are enforced during code review.
- **Guidance File**: Runtime development guidance lives in `sop.md`
  at the project root; it complements but does not override this
  constitution.

**Version**: 1.0.0 | **Ratified**: 2026-03-24 | **Last Amended**: 2026-03-24
