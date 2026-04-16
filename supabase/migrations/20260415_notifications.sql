-- ══════════════════════════════════════════════════════════
-- NOTIFICATIONS TABLE + TRIGGER
-- Run this in Supabase SQL Editor
-- ══════════════════════════════════════════════════════════

-- 1. Create notifications table
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL DEFAULT 'general',
  title TEXT NOT NULL,
  body TEXT NOT NULL DEFAULT '',
  related_id TEXT,          -- requestId or offerId
  related_route TEXT,       -- full route path for navigation
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Indexes
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON public.notifications(user_id, is_read) WHERE is_read = FALSE;

-- 3. RLS
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own notifications"
  ON public.notifications FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications"
  ON public.notifications FOR UPDATE
  USING (auth.uid() = user_id);

-- 4. Function to create notifications when offer status changes
CREATE OR REPLACE FUNCTION public.notify_on_offer_status_change()
RETURNS TRIGGER AS $$
DECLARE
  _request RECORD;
  _factory RECORD;
  _brand_user_id UUID;
BEGIN
  -- Get the related request
  SELECT * INTO _request FROM public.requests WHERE id = NEW.request_id;
  
  -- Get the factory info
  SELECT * INTO _factory FROM public.factories WHERE owner_id = NEW.factory_id;

  -- When a NEW offer is created → notify the brand owner
  IF TG_OP = 'INSERT' THEN
    INSERT INTO public.notifications (user_id, type, title, body, related_id, related_route)
    VALUES (
      _request.brand_id,
      'offer_received',
      'عرض جديد على طلبك 📩',
      'قدّم مصنع ' || COALESCE(_factory.name, 'مصنع') || ' عرضاً على طلبك',
      NEW.id,
      '/brand/requests/' || NEW.request_id || '/offers'
    );
  END IF;

  -- When offer is accepted → notify the factory owner
  IF TG_OP = 'UPDATE' AND NEW.status = 'accepted' AND OLD.status != 'accepted' THEN
    INSERT INTO public.notifications (user_id, type, title, body, related_id, related_route)
    VALUES (
      NEW.factory_id,
      'offer_accepted',
      'تم قبول عرضك! ✅',
      'تم قبول عرضك على الطلب: ' || COALESCE(_request.product_type, 'منتج'),
      NEW.id,
      '/factory/offers'
    );
  END IF;

  -- When offer is rejected → notify the factory owner
  IF TG_OP = 'UPDATE' AND NEW.status = 'rejected' AND OLD.status != 'rejected' THEN
    INSERT INTO public.notifications (user_id, type, title, body, related_id, related_route)
    VALUES (
      NEW.factory_id,
      'offer_rejected',
      'تم رفض عرضك ❌',
      'تم رفض عرضك على الطلب: ' || COALESCE(_request.product_type, 'منتج'),
      NEW.id,
      '/factory/offers'
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Trigger
DROP TRIGGER IF EXISTS trigger_offer_notification ON public.offers;
CREATE TRIGGER trigger_offer_notification
  AFTER INSERT OR UPDATE OF status ON public.offers
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_on_offer_status_change();

-- 6. Function to notify factory when new request is created
CREATE OR REPLACE FUNCTION public.notify_factories_on_new_request()
RETURNS TRIGGER AS $$
DECLARE
  _factory RECORD;
BEGIN
  -- Notify all factory owners about new requests
  FOR _factory IN SELECT DISTINCT owner_id FROM public.factories WHERE owner_id IS NOT NULL
  LOOP
    INSERT INTO public.notifications (user_id, type, title, body, related_id, related_route)
    VALUES (
      _factory.owner_id,
      'request_new',
      'طلب تصنيع جديد 📋',
      'تم إضافة طلب جديد: ' || COALESCE(NEW.product_type, 'منتج') || ' - ' || COALESCE(NEW.quantity::TEXT, '') || ' قطعة',
      NEW.id,
      '/factory/requests/' || NEW.id
    );
  END LOOP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7. Trigger for new requests
DROP TRIGGER IF EXISTS trigger_request_notification ON public.requests;
CREATE TRIGGER trigger_request_notification
  AFTER INSERT ON public.requests
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_factories_on_new_request();
