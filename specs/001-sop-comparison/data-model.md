# Data Model: SOP Alignment

## Existing Entities (No Changes)

### UserEntity
| Field | Type | Source |
|-------|------|--------|
| id | String (UUID) | Supabase auth.users |
| email | String | users.email |
| name | String | users.name |
| role | String (brand/factory) | users.role |
| brandName | String? | users.brand_name |
| phone | String? | users.phone |

### OfferEntity
| Field | Type | Source |
|-------|------|--------|
| id | String (UUID) | offers.id |
| requestId | String | offers.request_id |
| factoryId | String | offers.factory_id |
| factoryName | String | offers.factory_name |
| factoryRating | double | offers.factory_rating |
| pricePerPiece | double | offers.price_per_piece |
| leadTimeDays | int | offers.lead_time_days |
| notes | String? | offers.notes |
| status | OfferStatus (pending/accepted/rejected) | offers.status |

## Modified Entities

### RequestEntity ← ADD `quality` field
| Field | Type | Source | Change |
|-------|------|--------|--------|
| id | String (UUID) | requests.id | — |
| brandId | String | requests.brand_id | — |
| brandName | String | requests.brand_name | — |
| brandAvatarInitial | String? | requests.brand_avatar_initial | — |
| productType | String | requests.product_type | — |
| quantity | int | requests.quantity | — |
| **quality** | **RequestQuality** | **requests.quality** | **NEW** |
| material | String | requests.material | — |
| targetPricePerPiece | double? | requests.target_price_per_piece | — |
| notes | String? | requests.notes | — |
| referenceImageUrl | String? | requests.reference_image_url | — |
| status | RequestStatus | requests.status | — |
| offerCount | int | computed (view) | — |
| requestNumber | String? | requests.request_number | — |

```dart
enum RequestQuality { low, medium, high }
```

## New Entities

### FactoryProfileEntity (factory feature module)
| Field | Type | Source | Notes |
|-------|------|--------|-------|
| id | String (UUID) | factories.id | Auto-generated |
| ownerId | String | factories.owner_id | FK to auth.users |
| name | String | factories.name | Required |
| city | String | factories.city | Required |
| specialties | List\<String\> | factories.specialties | TEXT[] |
| minQuantity | int | factories.min_quantity | Default: 100 |
| leadTimeDays | int | factories.lead_time_days | Default: 21 |
| rating | double | factories.rating | Read-only, default: 0.0 |
| reviewCount | int | factories.review_count | Read-only, default: 0 |
| coverImageUrl | String? | factories.cover_image_url | Optional |
| portfolioImages | List\<String\> | factories.portfolio_images | TEXT[] |
| isFastResponder | bool | factories.is_fast_responder | Default: false |

## Schema Migration

```sql
-- Add quality field to requests table
ALTER TABLE public.requests
ADD COLUMN IF NOT EXISTS quality TEXT
  DEFAULT 'medium'
  CHECK (quality IN ('low', 'medium', 'high'));
```

## State Transitions

### FactoryProfileCubit
```
FactoryProfileInitial
  │
  ├──loadProfile()──→ FactoryProfileLoading → FactoryProfileLoaded(entity)
  │                                         → FactoryProfileNotFound
  │                                         → FactoryProfileError(message)
  │
  ├──createProfile()──→ FactoryProfileLoading → FactoryProfileCreated(entity)
  │                                           → FactoryProfileError(message)
  │
  └──updateProfile()──→ FactoryProfileLoading → FactoryProfileUpdated(entity)
                                              → FactoryProfileError(message)
```

### RequestsCubit (existing — add quality param)
```
createRequest(
  productType, quantity, material,
  quality,  ← NEW PARAMETER
  targetPrice?, notes?, referenceImageUrl?
)
```
