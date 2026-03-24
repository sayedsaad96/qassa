import 'package:supabase_flutter/supabase_flutter.dart';

/// Provides current user profile data.
/// Single source of truth — cubits and pages should use this
/// instead of calling Supabase.instance.client directly.
class UserService {
  final SupabaseClient _client;
  UserService(this._client);

  // ── Auth ─────────────────────────────────────────────
  String? get currentUserId => _client.auth.currentUser?.id;
  bool get isLoggedIn => _client.auth.currentSession != null;

  // ── Profile (cached after first load) ────────────────
  Map<String, dynamic>? _cachedProfile;

  Future<Map<String, dynamic>?> getProfile({bool forceRefresh = false}) async {
    final uid = currentUserId;
    if (uid == null) return null;

    if (_cachedProfile != null && !forceRefresh) return _cachedProfile;

    try {
      _cachedProfile = await _client
          .from('users')
          .select()
          .eq('id', uid)
          .maybeSingle();
      return _cachedProfile;
    } catch (_) {
      return null;
    }
  }

  Future<String?> get role async {
    final profile = await getProfile();
    return profile?['role'] as String?;
  }

  Future<String> get displayName async {
    final profile = await getProfile();
    final name = profile?['name'] as String? ?? '';
    return name.split(' ').first;
  }

  Future<String> get brandName async {
    final profile = await getProfile();
    return profile?['brand_name'] as String? ?? 'براند';
  }

  Future<String> get avatarInitial async {
    final profile = await getProfile();
    final name = profile?['name'] as String? ?? 'M';
    return name.isNotEmpty ? name[0].toUpperCase() : 'M';
  }

  // ── Factory profile ───────────────────────────────────
  Map<String, dynamic>? _cachedFactory;

  Future<Map<String, dynamic>?> getFactoryProfile({
    bool forceRefresh = false,
  }) async {
    final uid = currentUserId;
    if (uid == null) return null;

    if (_cachedFactory != null && !forceRefresh) return _cachedFactory;

    try {
      _cachedFactory = await _client
          .from('factories')
          .select()
          .eq('owner_id', uid)
          .maybeSingle();
      return _cachedFactory;
    } catch (_) {
      return null;
    }
  }

  Future<String> get factoryName async {
    final factory = await getFactoryProfile();
    return factory?['name'] as String? ?? 'مصنعك';
  }

  // ── Stats ─────────────────────────────────────────────
  Future<Map<String, int>> getFactoryStats() async {
    final uid = currentUserId;
    if (uid == null) return {'requests': 0, 'offers': 0, 'accepted': 0};

    try {
      final requestsResult = await _client
          .from('requests')
          .select('id')
          .eq('status', 'active')
          .count();

      final offersResult = await _client
          .from('offers')
          .select()
          .eq('factory_id', uid);

      final offers = List<Map<String, dynamic>>.from(offersResult);
      final accepted = offers.where((o) => o['status'] == 'accepted').length;

      return {
        'requests': requestsResult.count,
        'offers': offers.length,
        'accepted': accepted,
      };
    } catch (_) {
      return {'requests': 0, 'offers': 0, 'accepted': 0};
    }
  }

  void clearCache() {
    _cachedProfile = null;
    _cachedFactory = null;
  }
}
