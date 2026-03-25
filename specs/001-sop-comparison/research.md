# Research: SOP Alignment

## R-001: Factory Module Architecture

**Decision**: Mirror the brand module's architecture for the factory
module — `data/`, `domain/`, `presentation/` layers with the same
patterns (datasource → repository → use case → cubit).

**Rationale**: The brand module already establishes the project's clean
architecture pattern. The factory module currently violates this by
having only `presentation/` and importing brand/offers modules directly.
Following the same pattern ensures consistency and constitution
compliance (Principle I).

**Alternatives considered**:
- Shared domain layer between brand and factory → Rejected because
  it creates tight coupling and makes features harder to extract
  or modify independently.
- Factory-only cubit without full architecture → Rejected because
  it violates the constitution's non-negotiable clean architecture
  requirement.

## R-002: Factory Entity Reuse vs. Duplication

**Decision**: The factory feature will define its own
`FactoryProfileEntity` that is structurally similar to the brand
module's `FactoryEntity`, but owned by the factory feature.

**Rationale**: Each feature module should own its own entities per
clean architecture. The brand module's `FactoryEntity` represents a
factory as viewed by a brand (read-only browsing). The factory module's
entity represents a factory as managed by its owner (read-write profile).

**Alternatives considered**:
- Import brand's `FactoryEntity` directly → Rejected because it
  creates a cross-module dependency. Changes to the brand entity
  would break factory features.
- Shared entity in `core/` → Rejected because entities are feature-
  specific domain concepts, not framework-level utilities.

## R-003: Factory Pages in Single File

**Decision**: Extract the monolithic `factory_shell_page.dart`
(1116 lines) into separate page files matching existing stub filenames.

**Rationale**: The current implementation has all factory pages in one
file with other files as barrel exports (`export 'factory_shell_page.dart'`).
This violates constitution Principle I (max 300 lines/class) and makes
the codebase harder to navigate. The router already imports from separate
filenames, so extraction is seamless.

**Alternatives considered**:
- Keep everything in one file → Rejected because it exceeds the
  300-line class limit and violates code quality principles.
- Create entirely new pages from scratch → Rejected because the
  existing UI code is functional and only needs to be moved.

## R-004: Quality Field Design

**Decision**: Add a `quality` TEXT field to the `requests` table with
CHECK constraint (`'low'`, `'medium'`, `'high'`), defaulting to
`'medium'`. Map to a Dart enum `RequestQuality`.

**Rationale**: The SOP §5.3 specifies Quality Level as a required
field on requests (Low/Medium/High). This is currently missing from
both the schema and the Dart models. The field should be nullable in
migration to avoid breaking existing rows.

**Alternatives considered**:
- Use an integer scale (1-3) → Rejected because the SOP explicitly
  names Low/Medium/High and string enums are more readable in the DB.
- Make it required in schema → Rejected because existing rows lack
  the field; must be nullable with a default for backward compatibility.

## R-005: Legacy OTP Code

**Decision**: Delete `otp_page.dart`, rename `phone_auth_page.dart` →
`email_auth_page.dart`, rename `send_otp_usecase.dart` → `auth_usecases.dart`.

**Rationale**: The auth flow was migrated from phone OTP to email/password
in a previous conversation. The old files remain with misleading names.
The SOP (§4.1) specifies email & password as the sole auth mechanism.
No OTP-related code should remain.

**Alternatives considered**:
- Keep files with old names → Rejected because misleading filenames
  create confusion and violate the constitution's code quality principle.
- Rename without deleting OTP page → Rejected because dead code must
  be removed per constitution.

## R-006: Freezed Migration

**Decision**: Perform the `freezed` + `json_serializable` migration for all entities and models in a dedicated phase (Phase 7) prior to final polish.

**Rationale**: The constitution mandates `freezed` for all models (Principle I). While initially considered for deferral due to conflict risk, skipping this creates immediate technical debt and violates the pre-commit gate. By placing it in its own phase after page extraction, we isolate the risk while remaining constitution-compliant.

**Alternatives considered**:
- Migrate models during factory architecture build → Rejected because it multiplies the PR surface area and conflict risk mid-sprint.
- Defer to post-MVP → Rejected because it violates a NON-NEGOTIABLE constitution principle.
