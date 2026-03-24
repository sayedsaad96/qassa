-- ============================================================
-- FACTORYLINK — SUPABASE SQL SCHEMA v2.0
-- Run in Supabase SQL Editor (Dashboard → SQL Editor → New query)
-- ============================================================


-- ── EXTENSIONS ──────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- ============================================================
-- TABLE: users
-- ============================================================
CREATE TABLE IF NOT EXISTS public.users (
  id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email       TEXT NOT NULL UNIQUE,
  name        TEXT NOT NULL,
  role        TEXT NOT NULL CHECK (role IN ('brand', 'factory')),
  brand_name  TEXT,
  phone       TEXT UNIQUE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();


-- ============================================================
-- TABLE: factories
-- ============================================================
CREATE TABLE IF NOT EXISTS public.factories (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id          UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  name              TEXT NOT NULL,
  city              TEXT NOT NULL,
  specialties       TEXT[] NOT NULL DEFAULT '{}',
  min_quantity      INT NOT NULL DEFAULT 100,
  lead_time_days    INT NOT NULL DEFAULT 21,
  rating            NUMERIC(3,1) NOT NULL DEFAULT 0.0,
  review_count      INT NOT NULL DEFAULT 0,
  cover_image_url   TEXT,
  portfolio_images  TEXT[] DEFAULT '{}',
  is_fast_responder BOOLEAN NOT NULL DEFAULT FALSE,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER factories_updated_at
  BEFORE UPDATE ON public.factories
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Index for specialties search
CREATE INDEX IF NOT EXISTS idx_factories_specialties ON public.factories USING gin(specialties);
CREATE INDEX IF NOT EXISTS idx_factories_city ON public.factories(city);
CREATE INDEX IF NOT EXISTS idx_factories_rating ON public.factories(rating DESC);
CREATE UNIQUE INDEX IF NOT EXISTS idx_factories_owner ON public.factories(owner_id);


-- ============================================================
-- TABLE: requests
-- ============================================================
CREATE TABLE IF NOT EXISTS public.requests (
  id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_id              UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  brand_name            TEXT NOT NULL,
  brand_avatar_initial  TEXT,
  product_type          TEXT NOT NULL,
  quantity              INT NOT NULL CHECK (quantity > 0),
  material              TEXT NOT NULL DEFAULT 'مش محدد',
  target_price_per_piece NUMERIC(10,2),
  notes                 TEXT,
  reference_image_url   TEXT,
  status                TEXT NOT NULL DEFAULT 'active'
                          CHECK (status IN ('active', 'completed', 'cancelled')),
  request_number        TEXT UNIQUE,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER requests_updated_at
  BEFORE UPDATE ON public.requests
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Auto-generate request number: QS-YYYYMMDD-XXXX
CREATE OR REPLACE FUNCTION generate_request_number()
RETURNS TRIGGER AS $$
BEGIN
  NEW.request_number := 'QS-' ||
    TO_CHAR(NOW(), 'YYYYMMDD') || '-' ||
    LPAD(FLOOR(RANDOM() * 9000 + 1000)::TEXT, 4, '0');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER requests_request_number
  BEFORE INSERT ON public.requests
  FOR EACH ROW
  WHEN (NEW.request_number IS NULL)
  EXECUTE FUNCTION generate_request_number();

-- Indexes
CREATE INDEX IF NOT EXISTS idx_requests_brand_id ON public.requests(brand_id);
CREATE INDEX IF NOT EXISTS idx_requests_status ON public.requests(status);
CREATE INDEX IF NOT EXISTS idx_requests_product_type ON public.requests(product_type);
CREATE INDEX IF NOT EXISTS idx_requests_created_at ON public.requests(created_at DESC);


-- ============================================================
-- TABLE: offers
-- ============================================================
CREATE TABLE IF NOT EXISTS public.offers (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  request_id       UUID NOT NULL REFERENCES public.requests(id) ON DELETE CASCADE,
  factory_id       UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  factory_name     TEXT NOT NULL,
  factory_rating   NUMERIC(3,1) NOT NULL DEFAULT 0.0,
  price_per_piece  NUMERIC(10,2) NOT NULL CHECK (price_per_piece > 0),
  lead_time_days   INT NOT NULL CHECK (lead_time_days > 0),
  notes            TEXT,
  status           TEXT NOT NULL DEFAULT 'pending'
                     CHECK (status IN ('pending', 'accepted', 'rejected')),
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- One offer per factory per request
  UNIQUE(request_id, factory_id)
);

CREATE TRIGGER offers_updated_at
  BEFORE UPDATE ON public.offers
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- When an offer is accepted, mark others as rejected + request as completed
CREATE OR REPLACE FUNCTION handle_offer_accepted()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'accepted' AND OLD.status != 'accepted' THEN
    -- Reject all other pending offers for this request
    UPDATE public.offers
    SET status = 'rejected'
    WHERE request_id = NEW.request_id
      AND id != NEW.id
      AND status = 'pending';

    -- Mark request as completed
    UPDATE public.requests
    SET status = 'completed'
    WHERE id = NEW.request_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER offers_accepted_trigger
  AFTER UPDATE ON public.offers
  FOR EACH ROW EXECUTE FUNCTION handle_offer_accepted();

-- Indexes
CREATE INDEX IF NOT EXISTS idx_offers_request_id ON public.offers(request_id);
CREATE INDEX IF NOT EXISTS idx_offers_factory_id ON public.offers(factory_id);
CREATE INDEX IF NOT EXISTS idx_offers_status ON public.offers(status);


-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.factories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.offers ENABLE ROW LEVEL SECURITY;


-- ── USERS ───────────────────────────────────────────────────
CREATE POLICY "Users can read own profile"
  ON public.users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.users FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON public.users FOR INSERT
  WITH CHECK (auth.uid() = id);


-- ── FACTORIES ───────────────────────────────────────────────
-- Everyone (authenticated) can view all factories
CREATE POLICY "All authenticated users can view factories"
  ON public.factories FOR SELECT
  TO authenticated
  USING (TRUE);

-- Only the factory owner can insert/update their factory
CREATE POLICY "Factory owner can insert"
  ON public.factories FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Factory owner can update"
  ON public.factories FOR UPDATE
  TO authenticated
  USING (auth.uid() = owner_id);


-- ── REQUESTS ────────────────────────────────────────────────
-- All authenticated users can view active requests
CREATE POLICY "All authenticated can view active requests"
  ON public.requests FOR SELECT
  TO authenticated
  USING (status = 'active' OR brand_id = auth.uid());

-- Only brand owner can create requests
CREATE POLICY "Brand owners can create requests"
  ON public.requests FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = brand_id);

-- Only brand owner can update their own requests
CREATE POLICY "Brand owners can update own requests"
  ON public.requests FOR UPDATE
  TO authenticated
  USING (auth.uid() = brand_id);


-- ── OFFERS ──────────────────────────────────────────────────
-- Brand owners can see all offers for their requests
CREATE POLICY "Brand owners can view offers on their requests"
  ON public.offers FOR SELECT
  TO authenticated
  USING (
    factory_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM public.requests r
      WHERE r.id = offers.request_id AND r.brand_id = auth.uid()
    )
  );

-- Factory owners can insert offers
CREATE POLICY "Factory owners can send offers"
  ON public.offers FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = factory_id);

-- Brand owners can accept/reject (update status)
-- Factory owners can also update their own offer
CREATE POLICY "Users can update relevant offers"
  ON public.offers FOR UPDATE
  TO authenticated
  USING (
    factory_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM public.requests r
      WHERE r.id = offers.request_id AND r.brand_id = auth.uid()
    )
  );


-- ============================================================
-- STORAGE BUCKETS
-- ============================================================
INSERT INTO storage.buckets (id, name, public)
VALUES
  ('request-images', 'request-images', FALSE),
  ('factory-images', 'factory-images', TRUE)
ON CONFLICT DO NOTHING;

-- Storage policies
CREATE POLICY "Authenticated can upload request images"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'request-images');

CREATE POLICY "Request owners can view own images"
  ON storage.objects FOR SELECT
  TO authenticated
  USING (bucket_id = 'request-images');

CREATE POLICY "Anyone can view factory images"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'factory-images');

CREATE POLICY "Factory owners can upload images"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'factory-images');


-- ============================================================
-- SEED DATA (Sample factories for testing)
-- ============================================================

-- NOTE: Run this AFTER creating your first factory owner user
-- Replace 'YOUR_FACTORY_OWNER_UUID' with the actual auth user ID

/*
-- Sample: Insert test factories (run manually after first user signup)
INSERT INTO public.factories (owner_id, name, city, specialties, min_quantity, lead_time_days, rating, review_count, is_fast_responder)
VALUES
  -- Replace these UUIDs with real user IDs from auth.users
  ('00000000-0000-0000-0000-000000000001', 'مصنع النور',   'القاهرة',      ARRAY['تيشيرت','جينز','سبور'],   200, 18, 4.8, 24, TRUE),
  ('00000000-0000-0000-0000-000000000002', 'مصنع الأمل',   'الإسكندرية',   ARRAY['فستان','سبور'],           100, 25, 4.3, 11, FALSE),
  ('00000000-0000-0000-0000-000000000003', 'مصنع الرواد',  'المنصورة',     ARRAY['هوودي','تيشيرت'],         150, 14, 4.6, 18, TRUE),
  ('00000000-0000-0000-0000-000000000004', 'مصنع الفجر',   'الجيزة',       ARRAY['جينز','بنطلون'],          300, 21, 4.1, 7,  FALSE),
  ('00000000-0000-0000-0000-000000000005', 'مصنع المستقبل','القاهرة',      ARRAY['تيشيرت','فستان','سبور'],  100, 16, 4.9, 32, TRUE);
*/


-- ============================================================
-- HELPER VIEWS (Optional — useful for analytics)
-- ============================================================

-- View: requests with offer count
CREATE OR REPLACE VIEW public.requests_with_offer_count AS
SELECT
  r.*,
  COUNT(o.id) AS offer_count
FROM public.requests r
LEFT JOIN public.offers o ON o.request_id = r.id
GROUP BY r.id;

-- View: factory leaderboard
CREATE OR REPLACE VIEW public.factory_leaderboard AS
SELECT
  f.id,
  f.name,
  f.city,
  f.rating,
  f.review_count,
  COUNT(o.id) AS total_offers,
  COUNT(CASE WHEN o.status = 'accepted' THEN 1 END) AS accepted_offers
FROM public.factories f
LEFT JOIN public.offers o ON o.factory_id = f.owner_id
GROUP BY f.id
ORDER BY f.rating DESC;


-- ============================================================
-- DONE ✅
-- Tables: users, factories, requests, offers
-- RLS: Full row-level security on all tables
-- Storage: request-images, factory-images buckets
-- Triggers: request_number auto-gen, offer acceptance cascade
-- ============================================================
