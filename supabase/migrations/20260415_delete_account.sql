-- ══════════════════════════════════════════════════════════
-- DELETE USER ACCOUNT FUNCTION
-- Run this in Supabase SQL Editor
-- Required for Google Play & App Store compliance
-- ══════════════════════════════════════════════════════════

-- This function deletes all user data and their auth account.
-- Called via: _client.rpc('delete_user_account')
CREATE OR REPLACE FUNCTION public.delete_user_account()
RETURNS void AS $$
DECLARE
  _uid UUID := auth.uid();
BEGIN
  IF _uid IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  -- 1. Delete notifications
  DELETE FROM public.notifications WHERE user_id = _uid;

  -- 2. Delete offers made by this user (as factory)
  DELETE FROM public.offers WHERE factory_id = _uid;

  -- 3. Delete offers on requests owned by this user (as brand)
  DELETE FROM public.offers WHERE request_id IN (
    SELECT id FROM public.requests WHERE brand_id = _uid
  );

  -- 4. Delete requests
  DELETE FROM public.requests WHERE brand_id = _uid;

  -- 5. Delete factory profile
  DELETE FROM public.factories WHERE owner_id = _uid;

  -- 6. Delete avatar from storage (metadata only, actual files cleaned by lifecycle)
  DELETE FROM storage.objects
    WHERE bucket_id = 'avatars'
    AND name LIKE 'avatars/' || _uid::text || '/%';

  -- 7. Delete user profile
  DELETE FROM public.users WHERE id = _uid;

  -- 8. Delete auth user (requires service_role, so we use admin API)
  -- This is handled by the auth.users CASCADE or by Supabase Edge Function
  -- For RPC approach, we mark the user for deletion
  DELETE FROM auth.users WHERE id = _uid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.delete_user_account() TO authenticated;
